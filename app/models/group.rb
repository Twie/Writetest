class Group < ActiveRecord::Base
  has_many :users, through: :user_groups
  has_many :user_groups, :dependent => :destroy
  has_many :sentences
  validates_presence_of :title
  validates_uniqueness_of :title
  accepts_nested_attributes_for :users

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
      if current_user and current_user.sentences.where(:group_id => self.id).blank? and current_user_group.created_at > Time.now - 24.hours
        created_at_hash = [current_user] + created_at_hash 
      else
        last_user = created_at_hash.last
        first_user = created_at_hash[0]
        last_sentence_by_last_user = last_user.sentences.where(:group_id=>self.id).last
        last_user_group = UserGroup.find_by_group_id_and_user_id(self.id, last_user.id)
        timestamp_for_comparison = last_sentence_by_last_user.present? ? last_sentence_by_last_user.created_at : 10.years.ago
        puts timestamp_for_comparison
        if last_user_group.skipped_count.nil?
          last_user_group.skipped_count = 0
          last_user_group.save
        end
        if(last_user_group.skipped_count > 0)
          timestamp_for_comparison = [last_sentence_by_last_user.created_at, last_user_group.updated_at].max
        end
        if(timestamp_for_comparison < Time.now - 24.hours)
          if(self.users.count > 1)
            created_at_hash.delete(first_user)
            created_at_hash.push(first_user)
          end
          user_group = UserGroup.find_by_group_id_and_user_id(self.id, first_user.id)
          if user_group.skipped_count.nil?
            user_group.skipped_count = 0
          end
          user_group.skipped_count =  user_group.skipped_count+1
          if(user_group.skipped_count >= 2 && self.users.count > 1)
            UserGroup.destroy(user_group.id)
          else
            user_group.save
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
