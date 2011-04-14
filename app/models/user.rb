require 'facebook'

class User < ActiveRecord::Base
  
  attr_accessible :login, :email, :password, :password_confirmation
  
  has_one :authorization, :dependent => :destroy
  
  has_many :facebook_friends
  has_one :facebook_status
  
  has_many :twitter_followers
  has_one :twitter_status
  
  has_many :contacts
  
  acts_as_authentic do |c|
    c.merge_validates_length_of_password_field_options({:minimum => 6})
    c.ignore_blank_passwords = true
  end
  
  #here we add required validations for a new record and pre-existing record
  validate do |user|
    if user.new_record? #adds validation if it is a new record
      user.errors.add(:password, "is required") if user.password.blank? 
      user.errors.add(:password_confirmation, "is required") if user.password_confirmation.blank?
      user.errors.add(:password, "Password and confirmation must match") if user.password != user.password_confirmation
    elsif !(!user.new_record? && user.password.blank? && user.password_confirmation.blank?) #adds validation only if password or password_confirmation are modified
      user.errors.add(:password, "is required") if user.password.blank?
      user.errors.add(:password_confirmation, "is required") if user.password_confirmation.blank?
      user.errors.add(:password, " and confirmation must match.") if user.password != user.password_confirmation
      user.errors.add(:password, " and confirmation should be atleast 6 characters long.") if user.password.length < 6 || user.password_confirmation.length < 6
    elsif user.social_login            
      user.errors.clear
      user.errors.add(:email, "is required.") if user.email.blank?
      user.errors.add(:email, "is atleast 6 characters long.") if user.email.length < 6
      user.errors.add(:email, "is should be in email format.") if !user.validates_format_of(:email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i)      
    end
  end
  
  def self.find_by_username_or_email(login)
    self.find_by_login(login) || self.find_by_email(login)    
  end
  
  def activate!
    self.active = true
    save(false)
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
  
  #social login user
  def self.create_from_hash(hash)        
    user = User.new({:login => hash['user_info']['name'].to_s.downcase})
    user.social_login = true
    user.save(false)
    user.activate!
    user.reset_persistence_token! #set persistence_token else sessions will not be created
    user
  end
  
  def facebook          
    @fb_user ||= FbGraph::User.me(self.authorization.token)
  end
  
  def twitter
    unless @twitter_user
      provider = self.authorization
      @twitter_user = Twitter::Client.new(:oauth_token => provider.token, :oauth_token_secret => provider.secret) rescue nil
    end
    @twitter_user
end
  
  
end
