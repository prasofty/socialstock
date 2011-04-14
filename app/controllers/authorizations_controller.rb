class AuthorizationsController < ApplicationController
  before_filter :require_user, :only => [:destroy]
  
  def create
    omniauth = request.env['omniauth.auth']    
    @auth = Authorization.find_from_hash(omniauth)    
    if current_user
      flash[:notice] = "Successfully added #{omniauth['provider']} authentication"
      current_user.authorizations.create(:provider => omniauth['provider'], :uid => omniauth['uid'])   
    elsif @auth
      flash[:notice] = "Welcome back #{omniauth['provider']} user"
      UserSession.create(@auth.user, true)
      #update token and secret
      @auth.update_attributes({:token =>(omniauth['credentials']['token'] rescue nil), :secret => (omniauth['credentials']['secret'] rescue nil)})
            
    else  
      @auth = Authorization.create_from_hash(omniauth, current_user)
      flash[:notice] = "Welcome #{omniauth['provider']} user. Your account has been created."
      UserSession.create(@auth.user, true)
    end
    
    redirect_to user_path(@auth.user.id)
  end
    
  def failure
    flash[:error] = "Sorry, You did n't authorize"
    redirect_to root_url
  end
  
  def destroy
    @authorization = current_user.authorizations.find(params[:id])
    flash[:notice] = "Successfully deleted #{@authorization.provider} authentication."
    @authorization.destroy
    redirect_to root_url
  end
end