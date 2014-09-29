class Sentence < ActiveRecord::Base
	validates :content,
	presence: true,
	length: {
    minimum: 5,
    maximum: 140,
    too_short: "must have at least %{count} characters",
    too_long: "must have at most %{count} characters"
  }

  def self.save
  	@chapter = self.all
    File.open("chapter.txt", "w") { |file| file.write @chapter.join("\n") }
  end

end
