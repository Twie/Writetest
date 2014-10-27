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
    @token = generate_invite_token(email_id, group)
    invite_to_join_group = group.join_group_email_invitations.create(:email_id=>email_id)
    invite_to_join_group.save
    mail(to:email_id, subject: "#{group.title} group join invitation from #{group_creator.firstname}!")
  end
  
  def invite_to_join_group(group_creator, group, user)
    @group = group
    @group_creator = group_creator
    @user = user
    @token = generate_invite_token(user.email, group)
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
    @token = generate_invite_token(user.email, group)
    mail(to:user.email, subject: "You have been kicked out of #{group.title}!")
  end
  
  private
  def generate_invite_token(email, group)
    key = ENV['encoding_key']
    puts key
    puts email
    signature = email+group.id.to_s
    generated_token = CGI.escape(Base64.encode64("#{OpenSSL::HMAC.digest('sha1',key, signature)}\n"))
  end
end
