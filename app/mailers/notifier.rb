class Notifier < ActionMailer::Base
  default :from => "prasanna548@gmail.com"  
  
  def welcome_email(user)    
    @user_email = user
    @url = root_url
    
    @web_site = WEB_SITE
    
    mail(:to => @user_email[:email],
         :subject => "Welcome to the site")
  end
  
  def password_reset_instruction(user)
    subject "Password Reset Instructions"    
    recipients user.email
    context_type "text/html"
    sent_on Time.now
    body :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end
