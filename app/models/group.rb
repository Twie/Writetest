class Group < ActiveRecord::Base
  has_many :users, through: :user_groups
  has_many :user_groups, :dependent => :destroy
  has_many :sentences
  accepts_nested_attributes_for :users
  
  def next_chance
    members_count = self.users.count
    sentencesSoFar = self.sentences.count
    members = self.users
    if(sentencesSoFar > members_count)

    else
    members = []
    end
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
    created_at_hash = [current_user] + created_at_hash if current_user and current_user.sentences.where(:group_id => self.id).blank?
    created_at_hash.uniq
  end
end
