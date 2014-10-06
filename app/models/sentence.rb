class Sentence < ActiveRecord::Base
  LINES_PER_CHAPTER = 100
	validates :content,
	presence: true,
	length: {
    minimum: 5,
    maximum: 140,
    too_short: "must have at least %{count} characters",
    too_long: "must have at most %{count} characters"
  }
  belongs_to :user
  belongs_to :group
end
