class Notifier < ActionMailer::Base
  default :from => "prasanna548@gmail.com"
  
  def activation_instructions(user)    
    @account_activation_url = activate_url(user[:perishable_token])
    mail(:to => user[:email],
         :subject => "Activation Instructions #{WEB_SITE}")
  end
  
  def welcome_email(user)
    @root_url = root_url
    @username = user.login
    @website = WEB_SITE
    mail(:to => user.email,
         :subject => "Welcome to the site! #{WEB_SITE}")
  end
  
  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(:to => user.email,
         :subject => "Password Reset Instructions") 
  end
end
