class Notifier < ActionMailer::Base
  default :from => "from@example.com"
  default_url_options[:host] = "localhost.com:3000"
  
  def welcome_email(user)
    @user = user
    @url = root_url
    mail(:to => user.email,
         :subject => "Welcome to the site")
  end
  
  def password_reset_instruction(user)
    subject "Password Reset Instructions"
    from "noreplay@example.com"
    recipients user.email
    context_type "text/html"
    sent_on Time.now
    body :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end
