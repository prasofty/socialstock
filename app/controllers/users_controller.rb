class UsersController < ApplicationController  
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def index
    
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "User sign up successfully!"
      #TODO User Activation code     
      user = {:email => @user.email, :login => @user.login}
      Notifier.welcome_email(user).deliver
      redirect_back_or_default user_path(@user.id)
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
