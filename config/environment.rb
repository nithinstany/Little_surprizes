# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  #SITE_URL = 'http://localhost:3000/'
  #FACEBOOK_URL = "http://apps.facebook.com/testlittlesurpize/" 
  
  SITE_URL = 'http://69.164.222.92:3000/'
  FACEBOOK_URL = "http://apps.facebook.com/littlesurprizes/"

  config.gem "authlogic"

  config.gem "mechanize", :lib => 'mechanize', :version => '1.0.0'
  config.time_zone = 'UTC'

  
  config.action_controller.session_store = :active_record_store


  
end

