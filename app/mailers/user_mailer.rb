class UserMailer < ActionMailer::Base
  default from: '"YesAndApp"<YesAndApp@gmail.com>'
  
  def welcome
    mail(to: "sil.demmer@gmail.com", subject: "Trial") do |format|
      format.html { render :text => "Lets do it"}
    end
  end
  
  def notify_of_turn(nextup, sentence, group)
    @nextup = nextup
    @sentence = sentence
    @group = group
    mail(to: nextup.email, subject: "It's your turn!")
  end
  
  def notify_of_completion(group)
    @group = group
    mail(to: [], bcc: group.users.map(&:email), subject: "Submissions for #{group.title} are complete!")
  end
  
  def invite_to_join_app(group_creator, group, email_id)
    @group = group
    @group_creator = group_creator
    mail(to:email_id, subject: "#{group.title} group join invitation from #{group_creator.firstname}!")
  end
  
  def invite_to_join_group(group_creator, group, user)
    @group = group
    @group_creator = group_creator
    @user = user
    mail(to:user.email, subject: "#{group.title} group join invitation from #{group_creator.firstname}!")
  end
  
  def notify_of_skip_chance(user, group)
    @user= user
    @group = group
    mail(to:user.email, subject: "Your chance for #{group.title} has been skipped!")
  end
  
  def notify_of_group_eviction(user, group)
    @user= user
    @group = group
    mail(to:user.email, subject: "You have been kicked out of #{group.title}!")
  end
end
