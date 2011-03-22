class User < ActiveRecord::Base
  
  attr_accessible :login, :email, :password, :password_confirmation
  
  acts_as_authentic do |c|
    c.merge_validates_length_of_password_field_options({:minimum => 6})
  end 
  
  def self.find_by_username_or_email(login)
    self.find_by_login(login) || self.find_by_email(login)    
  end
  
  def activate!
    self.active = true
    save
  end
  
  def devliver_activation_instructions!    
    reset_perishable_token!    
  end
  
  def devliver_welcome_mail!
    reset_perishable_token!
    if ENV['RAILS_ENV'] == "development"
      welcome_email = Notifier.welcome_email(self)
      logger.debug welcome_email
    else
      Notifier.welcome_email(self).deliver
    end
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    if ENV['RAILS_ENV'] == "development"
      reset_password = Notifier.password_reset_instructions(self)
      logger.debug reset_password
    else
      Notifier.password_reset_instructions(self).deliver      
    end
  end
end
