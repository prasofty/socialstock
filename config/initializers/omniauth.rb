require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, FACEBOOK_APP_ID, FACEBOOK_APP_SECRET
    provider :twitter, TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET
    provider :linked_in, LINKEDIN_API_KEY, LINKEDIN_SECRET_KEY
    provider :open_id, OpenID::Store::Filesystem.new('/tmp')    
end

#ActionController::Dispatcher.middleware do
#  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => "google",  :identifier => "https://www.google.com/accounts/o8/id"
#end