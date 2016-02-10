module Subpop
  class Application < Rails::Application
    config.to_prepare do
      Flickr::Client.setup do |config|
        config.flickr_api_key       = ENV['SUBPOP_FLICKR_API_KEY']
        config.flickr_shared_secret = ENV['SUBPOP_FLICKR_API_SECRET']
        config.flickr_access_token  = ENV['SUBPOP_FLICKR_ACCESS_TOKEN']
        config.flickr_access_secret = ENV['SUBPOP_FLICKR_ACCESS_SECRET']
        config.flickr_userid        = ENV['SUBPOP_FLICKR_USERID']
        config.flickr_username      = ENV['SUBPOP_FLICKR_USERNAME']
      end

      Flickr::Client.validate
    end
  end
end