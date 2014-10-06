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
  after_create :send_email_to_nextup_user
  
  def send_email_to_nextup_user
    nextup = self.group.users_order.first
    unless nextup.id != self.user_id
      UserMailer.notify_of_turn(nextup, self).deliver
    end 
  end
end
