class BadWord < ActiveRecord::Base
  validates_presence_of :word
  
  def self.all_words
    BadWord.all.map(&:word).compact.map(&:downcase)
  end
end
