class UsersController < ApplicationController  
  before_filter :require_user, :only => [:show, :edit, :update] 
  
  def index
    
  end
  
  def new
    @user = User.new
  end
  
  def create
    params[:user][:social_login] = false
    @user = User.new(params[:user])
    if @user.save_without_session_maintenance
      flash[:notice] = "User sign up successfully! Please check your mail and follow instructions in that mail."      
      #User Activation code      
      @user.devliver_activation_instructions!
      user = {:email => @user.email, :perishable_token => @user.perishable_token}
      if ENV['RAILS_ENV'] == "development"        
        activation_mail = Notifier.activation_instructions(user)
        logger.debug activation_mail
      elsif ENV['RAILS_ENV'] == "production"
        Notifier.activation_instructions(user).deliver      
      end
      redirect_to root_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user  
  end

  def edit
    @user = @current_user
    @authorizations = current_user.authorization if current_user
  end
  
  def update
    @user = @current_user
    if !@user.social_login
      if @user.update_attributes(params[:user])
        flash[:notice] = "User details updated!"
        redirect_to user_path(@user.id)
      else
        render :action => :edit
      end
    else
      @user.email = params[:user][:email]     
      if @user.save        
        flash[:notice] = "User details updated!"
        redirect_to user_path(@user.id)
      else
        render :action => :edit
      end
    end
  end
  
  def change_password
    @user = User.find_by_id(current_user) 
  end
  
  def password_update
    @user = current_user    
        
    if @user.valid_password?(params[:old_password])
      if params[:password].length < 6
        flash[:error] = "New password should more then 6 characters"
        render :action => :change_password
      else
        if params[:password] != params[:password_confirmation]
          flash[:error] = "New password and confirm password should be same."
          render :action => :change_password
        else
          @user.password = params[:password]
          @user.password_confirmation = params[:password] 
          @user.save
          flash[:notice] = "Password changed successfully."          
          redirect_to user_path(current_user)
        end        
      end              
    else      
      flash[:error] = "Enter Correct password."
      render :action => :change_password
    end            
  end  
  
  def resend_activation
        
  end 
  
  def resent_activation
    @user = User.find_by_email(params[:email])
    if !@user.nil? 
      if @user.active?
        flash[:notice] = "Already Your account activated. Please Sign In."
        redirect_to root_path
      else
        #User Activation code
        @user.devliver_activation_instructions!
        user = {:email => @user.email, :perishable_token => @user.perishable_token}
        if ENV['RAILS_ENV'] == "development"
          activation_mail = Notifier.activation_instructions(user)
          logger.debug activation_mail
        elsif ENV['RAILS_ENV'] == "production"
          Notifier.activation_instructions(user).deliver      
        end
        
        flash[:notice] = "Activation mail sent, Please check your mail and follow instructions in that mail."
        redirect_to root_path        
      end      
    else
      flash[:error] = "We're sorry, but we could not locate your account."
      render :action => :resend_activation
    end
    
  end
end
