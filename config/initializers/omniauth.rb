require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, FACEBOOK_APP_ID, FACEBOOK_APP_SECRET, {:scope => 'publish_stream,offline_access,email'}
    provider :twitter, TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET
    provider :linked_in, LINKEDIN_API_KEY, LINKEDIN_SECRET_KEY
    provider :open_id, OpenID::Store::Filesystem.new('/tmp')    
end

#ActionController::Dispatcher.middleware do
#  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => "google",  :identifier => "https://www.google.com/accounts/o8/id"
#end

Twitter.configure do |config|
  config.consumer_key = TWITTER_CONSUMER_KEY
  config.consumer_secret = TWITTER_CONSUMER_SECRET
  config.oauth_token = ''
  config.oauth_token_secret = ''
end