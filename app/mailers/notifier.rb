class Notifier < ActionMailer::Base
  default :from => "prasanna548@gmail.com"
  
  def activation_instructions(user)    
    @account_activation_url = activate_url(user[:perishable_token])
    mail(:to => user[:email],
         :subject => "Activation Instructions #{WEB_SITE}")
  end
  
  def welcome_email(user)
    subject "Welcome to the site! #{WEB_SITE}"
    recipients    user.email   
    body          :root_url => root_url, :username => user.login, :website => WEB_SITE
  end
  
  def password_reset_instruction(user)
    subject "Password Reset Instructions"    
    recipients user.email
    context_type "text/html"
    sent_on Time.now
    body :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end
