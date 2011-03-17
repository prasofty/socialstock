class User < ActiveRecord::Base
  acts_as_authentic  
  
  def deliver_password_reset_instructions!
    reset_perishable_token! 
    self
    #TODO Need to fix email deliver
    #Notifier.password_reset_instructions(self).deliver
  end
end
