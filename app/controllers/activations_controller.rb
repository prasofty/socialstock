class ActivationsController < ApplicationController
  before_filter :require_no_user
  
  def create
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @user.active?
    
    if @user.activate!
      flash[:notice] = "Your account has been activated!"
      UserSession.create(@user, false) # Log user in manually
      @user.devliver_welcome_mail! #TODO welcome mail
      redirect_to user_path(@user.id)
    else 
      render :action => :new
    end
  end
end
