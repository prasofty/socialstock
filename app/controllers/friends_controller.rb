class FriendsController < ApplicationController
  
  def index
   
    if auth_provider.provider == 'facebook'
      @fb_friends = current_user.facebook_friends
      @fb_status = current_user.facebook_status
    elsif auth_provider.provider == 'twitter'
      @followers = current_user.twitter_followers
      @t_status = current_user.twitter_status
    elsif auth_provider.provider == 'open_id'
      @contacts = current_user.contacts
    end
  end
  
  def get_facebook_friends
    
    @fb = current_user.facebook
    @fb.fetch
    @fb_status = @fb.feed.first
    
    FacebookStatus.delete_all(:user_id => current_user.id)
    
    FacebookStatus.create({
      :user_id => current_user.id,
      :facebook_status_id => @fb_status.identifier,
      :name => @fb_status.name,
      :link => @fb_status.link,
      :caption => @fb_status.caption,
      :description => @fb_status.description,
      :source => @fb_status.source,
      :status_type => @fb_status.type
    })    
    
        
    @fb_friends = @fb.friends
    
    @fb_friends.each do |fb_friend|
      fb = current_user.facebook_friends.find_by_facebook_uid(fb_friend.identifier)
      fb.update_attributes({:name => fb_friend.name}) if !fb.nil?
      fb = FacebookFriend.create({:user_id => current_user.id, :facebook_uid => fb_friend.identifier, :name => fb_friend.name}) if fb.nil?      
    end   
        
    redirect_to friends_path(:source => 'facebook')
  end
  
  def get_twitter_followers
    
    @t = current_user.twitter
    
    @status = @t.user.status
    
    TwitterStatus.delete_all(:user_id => current_user.id)
    
    TwitterStatus.create({
      :user_id => current_user.id,
      :twitter_status_id => @status.id,
      :text => @status.text
    })
        
    @followers = @t.followers.users
    
    @followers.each do |follower|    
      t = TwitterFollower.find_by_twitter_id_and_user_id(follower.id, current_user.id)
      t.update_attributes({:name => follower.name}) if !t.nil?
      t = TwitterFollower.create({:user_id => current_user.id, :twitter_id => follower.id, :name => follower.name, :screen_name => follower.screen_name}) if t.nil?
    end
    
    redirect_to friends_path(:source => 'twitter')
  end
  
  def get_contacts
    
    @contacts = Contacts::Gmail.new(params[:username], params[:password]).contacts
    
    @contacts.each do |contact|
      c = Contact.find_by_email(contact[1])
      c.update_attributes({:username => contact[0]}) if !c.nil?
      Contact.create({:user_id => current_user.id, :source => 'gmail', :username => contact[0], :email => contact[1]})
    end
    
    redirect_to friends_path(:source => 'open_id')
  end
end
