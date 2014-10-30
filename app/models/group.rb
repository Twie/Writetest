class Group < ActiveRecord::Base
  has_many :users, through: :user_groups
  has_many :user_groups, :dependent => :destroy
  has_many :sentences
  has_many :join_group_email_invitations
  validates_presence_of :title
  validates_uniqueness_of :title
  accepts_nested_attributes_for :users
  before_create :convert_title_to_lower_case_and_add_default
  
  def convert_title_to_lower_case_and_add_default
    self.title.downcase!
    self.submissions_limit = 25 if self.submissions_limit.blank? 
  end

  def users_order(current_user = nil)
    created_at_hash = {}
    self.users.each{|user|
      sentence = user.sentences.where(:group_id => self.id).last
      if sentence.present?
        created_at_hash.merge!({user => sentence.created_at})
      else
        created_at_hash.merge!({user => 10.years.ago})
      end
    }
    created_at_hash = created_at_hash.sort_by{|k,v| v}.map{|a| a[0]}
    unless self.deactivate_group?
      current_user_group = current_user.user_groups.find_by_group_id(self.id)
      if current_user.sentences.where(:group_id => self.id).blank? and current_user_group.created_at > Time.now - 24.hours
        created_at_hash = [current_user] + created_at_hash 
      else
        last_user = created_at_hash.last
        first_user = created_at_hash[0]
        last_sentence_by_last_user = last_user.sentences.where(:group_id=>self.id).last
        last_user_group = UserGroup.find_by_group_id_and_user_id(self.id, last_user.id)
        if last_user_group.skipped_count.nil?
          last_user_group.skipped_count = 0
          last_user_group.save
        end
        do_not_skip = false
        if(last_user_group.skipped_count > 0)
          timestamp_for_comparison = last_sentence_by_last_user.present? ? last_sentence_by_last_user.created_at : 10.years.ago
          timestamp_for_comparison = [timestamp_for_comparison, last_user_group.updated_at].max
        elsif(last_user_group.skipped_count == 0 and !last_sentence_by_last_user.present?)
          do_not_skip = true
        elsif(last_user_group.skipped_count == 0 and last_sentence_by_last_user.present?)
          timestamp_for_comparison = last_sentence_by_last_user.created_at
        end
        if(do_not_skip == false and timestamp_for_comparison < Time.now - 24.hours)
          if(self.users.count > 1)
            created_at_hash.delete(first_user)
            created_at_hash.push(first_user)
          end
          user_group = UserGroup.find_by_group_id_and_user_id(self.id, first_user.id)
          if(user_group.updated_at < Time.now - 24.hours)
            if user_group.skipped_count.nil?
              user_group.skipped_count = 0
            end
            user_group.skipped_count =  user_group.skipped_count+1
            last_sentence_played_in_group = Sentence.where(:group_id => self.id).last
            if(user_group.skipped_count == 1 and self.users.count > 1)
              UserMailer.notify_of_skip_chance(first_user,self).deliver
              UserMailer.notify_of_turn(created_at_hash[0],last_sentence_played_in_group, self)
            end
            if(user_group.skipped_count >= 2 and self.users.count > 1)
              UserGroup.destroy(user_group.id)
              UserMailer.notify_of_group_eviction(first_user,self).deliver
              UserMailer.notify_of_turn(created_at_hash[0],last_sentence_played_in_group, self)
            else
              user_group.save
            end
          end
        end
      end
    end
    created_at_hash.uniq
  end
  
  def deactivate_group?
    self.submissions_limit <= self.sentences.count
  end
  
  def top_five_words
    bad_words = BadWord.all_words
    self.sentences.map(&:content).join(" ").split(" ").map(&:downcase).reject{|a| bad_words.include?(a)}.inject(Hash.new(0)) { |m, n| m[n] += 1; m }.sort_by{|k,v| -v}.first(5).map{|a| a[0]}
  end
end
