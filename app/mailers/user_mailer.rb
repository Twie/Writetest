class UserMailer < ActionMailer::Base
  default from: '"YesAndApp"<YesAndApp@gmail.com>'
  
  def welcome
    mail(to: "sil.demmer@gmail.com", subject: "Trial") do |format|
      format.html { render :text => "Lets do it"}
    end
  end
  
  def notify_of_turn(nextup, sentence)
    @nextup = nextup
    @sentence = sentence
    mail(to: nextup.email, subject: "It's your turn!")
  end
  
  def notify_of_completion(group)
    @group = group
    mail(to: [], bcc: group.users.map(&:email), subject: "Submissions for #{group.title} are complete!")
  end
end
