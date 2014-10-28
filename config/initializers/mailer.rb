ENV["host"] = Rails.env.development? ? "http://localhost:3000" : "http://yesandapp.com"
ActionMailer::Base.default_url_options[:host] =  ENV["host"]  
ActionMailer::Base.smtp_settings = {
  :address => 'smtp.gmail.com',
  :port => 587,
  :domain => ENV["host"],
  :user_name => ENV['email_username'],
  :password => ENV['email_secret'],
  :authentication => "plain",
  :enable_starttls_auto => true
}