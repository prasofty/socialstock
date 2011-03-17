class UserSessionsController < ApplicationController
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
    if current_user
      redirect_to user_path(current_user)
    end
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])    
    if @user_session.save      
      flash[:notice] = "Login successful!"      
      redirect_back_or_default user_path(current_user)
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
  
end
