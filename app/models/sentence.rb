class Sentence < ActiveRecord::Base
	validates :content,
	presence: true,
	length: {
    minimum: 5,
    maximum: 140,
    too_short: "must have at least %{count} characters",
    too_long: "must have at most %{count} characters"
  }
end
