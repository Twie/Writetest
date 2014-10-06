class UserMailer < ActionMailer::Base
  default from: "YesAndApp@gmail.com"
  
  def welcome
    mail(to: "sil.demmer@gmail.com", subject: "Trial") do |format|
      format.html { render :text => "Lets do it"}
    end
  end
end
