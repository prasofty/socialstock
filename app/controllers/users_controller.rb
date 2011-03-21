class UsersController < ApplicationController  
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def index
    
  end
  
  def new
    @user = User.new
  end
  
  def create
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
  end
  
  def update
    @user = @current_user 
    if @user.update_attributes(params[:user])
      flash[:notice] = "User details updated!"
      redirect_to user_path(@user.id)
    else
      render :action => :edit
    end
  end
end
