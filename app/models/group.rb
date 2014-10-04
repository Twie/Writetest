class Group < ActiveRecord::Base
  has_many :users, through: :user_groups
  has_many :user_groups, :dependent => :destroy
  has_many :sentences
  def next_chance
    members_count = self.users.count
    sentencesSoFar = self.sentences.count
    members = self.users
    if(sentencesSoFar > members_count)

    else
    members = []
    end
  end

  def users_order
    created_at_hash = {}
    self.users.each{|user|
      sentence = user.sentences.where(:group_id => self.id).last
      if sentence.present?
        created_at_hash.merge!({user => sentence.created_at})
      else
        created_at_hash.merge!({user => 10.years.ago})
      end
    }
    created_at_hash.sort_by{|k,v| v}.map{|a| a[0]}
  end
end
