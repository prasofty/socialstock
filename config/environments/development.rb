Socialstock::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin 
  
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
    
end

WEB_SITE = "localhost:3000"

TWITTER_CONSUMER_KEY = "dJMlAi9JGT7rCjiR79zDA"
TWITTER_CONSUMER_SECRET = "dIHhayg4abPhEBsoGOg47dUCXr4cnM9Ubs0QA5LyI"

FACEBOOK_APP_ID = "192100847492162"
FACEBOOK_APP_SECRET = "f500a4d0571ac03f41da2d64d65e25e6"

LINKEDIN_API_KEY = "1ST0rhcasj0eZNfB8WY9meiaEFfssvvsUXBv_hkaxCNPuWTB3Nb0n_96TnW6PiN8"
LINKEDIN_SECRET_KEY = "0wgjFmb4q-cmzrx6TF971f8Zhmbt0SKqU4WE_xc7N3PU5NJii4Y560adCFZt1t5M"