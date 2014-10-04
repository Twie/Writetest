class Sentence < ActiveRecord::Base
  LINES_PER_CHAPTER = 25
	validates :content,
	presence: true,
	length: {
    minimum: 5,
    maximum: 140,
    too_short: "must have at least %{count} characters",
    too_long: "must have at most %{count} characters"
  }
  belongs_to :user
  belongs_to :sentence

  def self.save
  	@chapter = self.all
    File.open("chapter.txt", "w") { |file| file.write @chapter.join("\n") }
  end

end
