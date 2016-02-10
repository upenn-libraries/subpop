# Flickr::Client uses FlickRaw for accessing Flickr.
module Flickr
  class Client

    # url_s : Square
    # url_q : Large Square
    # url_t : Thumbnail
    # url_m : Small
    # url_n : Small 320
    # url   : Medium
    # url_z : Medium 640
    # url_c : Medium 800
    # url_b : Large
    # url_o : Original
    # url_profile
    # url_photopage
    # url_photoset, url_photosets
    # url_short, url_short_m, url_short_s, url_short_t
    # url_photostream

    # Flickr API key
    cattr_accessor :flickr_api_key
    @@flickr_api_key       = nil

    # Flickr API secret
    cattr_accessor :flickr_shared_secret
    @@flickr_shared_secret = nil

    # Following items are specific to the POP Flickr user account. SubPOP has
    # a single Flickr account so we just connect to the one account.
    #
    # Flickr access token
    cattr_accessor :flickr_access_token
    @@flickr_access_token  = nil
    # Flickr access secret
    cattr_accessor :flickr_access_secret
    @@flickr_access_secret = nil
    # Flickr user ID; the POP account userid
    cattr_accessor :flickr_userid
    @@flickr_userid        = nil
    # Flickr user name; the POP account user name
    cattr_accessor :flickr_username
    @@flickr_username      = nil

    @@flickr_required_vars = [
     :@@flickr_api_key,
     :@@flickr_shared_secret,
     :@@flickr_access_token,
     :@@flickr_access_secret,
     :@@flickr_userid,
     :@@flickr_username
   ]

   # Not going to use rails cattr for this, so we create the getters and setters.

   class << self
    def setup
      yield self
    end

    def validate
      missing_attributes = []
      @@flickr_required_vars.each do |var|
        unless class_variable_get(var)
          name = var.to_s.sub(/^@@/, '')
          missing_attributes << "config.#{name} = ENV['#{name.upcase}']"
        end
      end

      unless missing_attributes.empty?
        raise <<-ERROR
Required Flickr::Client configuration variable(s) not set. Please set these in
the Flickr::Client initializer:

  #{missing_attributes.join "\n  "}

Please ensure you restarted your application after setting the variables.
ERROR
      end
    end

    def connect! options={}
      validate
      client                = Flickr::Client.new
      client.connect
      client
    end
  end

    def connect
      FlickRaw.api_key       = Flickr::Client.flickr_api_key
      FlickRaw.shared_secret = Flickr::Client.flickr_shared_secret
      @flickr                = FlickRaw::Flickr.new
      @flickr.access_token   = Flickr::Client.flickr_access_token
      @flickr.access_secret  = Flickr::Client.flickr_access_secret
      @login                 = @flickr.test.login
    end

    # Upload file to Flickr with provided metadata and return the
    # Flickr ID of the new photo. Metadata is hash containing any of
    # the allowed Flickr upload arguments (see
    # https://www.flickr.com/services/api/upload.api.html):
    #
    # :title (optional)
    #   The title of the photo.
    #
    # :description (optional)
    #   A description of the photo. May contain some limited HTML.
    #
    # :tags (optional)
    #   A space-seperated list of tags to apply to the photo.
    #
    # :is_public, :is_friend, :is_family (optional)
    #   Set to 0 for no, 1 for yes. Specifies who can view the photo.
    #
    # :safety_level (optional)
    #   Set to 1 for Safe, 2 for Moderate, or 3 for Restricted.
    #
    # :content_type (optional)
    #   Set to 1 for Photo, 2 for Screenshot, or 3 for Other.
    #
    # :hidden (optional)
    #   Set to 1 to keep the photo in global search results, 2 to hide
    #   from public searches.
    #
    #
    def upload file, metadata={}
      @flickr.upload_photo file, metadata
    end

    def get_info photo_id
      @flickr.photos.getInfo photo_id: photo_id
    end

    def set_tags photo_id, tags
      @flickr.photos.setTags photo_id: photo_id, tags: tags
    end

    def url info, url_type
      FlickRaw.send url_type, info
    end

    # photo_id (Required)
    #   The id of the photo to delete.
    #
    # ERROR CODES
    # ===========
    #
    # 1: Photo not found
    #   The photo id was not the id of a photo belonging to the
    #   calling user.
    #
    # 95: SSL is required
    #   SSL is required to access the Flickr API.
    #
    # 96: Invalid signature
    #   The passed signature was invalid.
    #
    # 97: Missing signature
    #   The call required signing but no signature was sent.
    #
    # 98: Login failed / Invalid auth token
    #   The login details or auth token passed were invalid.
    #
    # 99: User not logged in / Insufficient permissions
    #   The method requires user authentication but the user was not
    #   logged in, or the authenticated method call did not have the
    #   required permissions.
    #
    # 100: Invalid API Key
    #   The API key passed was not valid or has expired.
    #
    # 105: Service currently unavailable
    #   The requested service is temporarily unavailable.
    #
    # 106: Write operation failed
    #   The requested operation failed due to a temporary issue.
    #
    # 111: Format "xxx" not found
    #   The requested response format was not found.
    #
    # 112: Method "xxx" not found
    #   The requested method was not found.
    #
    # 114: Invalid SOAP envelope
    #   The SOAP envelope send in the request could not be parsed.
    #
    # 115: Invalid XML-RPC Method Call
    #   The XML-RPC request document could not be parsed.
    #
    # 116: Bad URL found
    #   One or more arguments contained a URL that has been used for
    #   abuse on Flickr.
    #
    def delete photo_id
      @flickr.photos.delete(photo_id: photo_id)
    end
  end
end
