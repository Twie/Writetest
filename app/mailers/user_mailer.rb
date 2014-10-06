class UserMailer < ActionMailer::Base
  default from: '"Sil Demmer"<YesAndApp@gmail.com>'
  
  def welcome
    mail(to: "sil.demmer@gmail.com", subject: "Trial") do |format|
      format.html { render :text => "Lets do it"}
    end
  end
  
  def notify_of_turn(nextup, sentence)
    @nextup = nextup
    @sentence = sentence
    mail(to: nextup.email, subject: "Now its your turn to keep the ball rolling!")
  end
  
  def notify_of_completion(group)
    @group = group
    mail(to: [], bcc: group.users.map(&:email), subject: "The submission for the #{group.title} are over!")
  end
end
