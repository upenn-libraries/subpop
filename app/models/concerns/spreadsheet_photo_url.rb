module SpreadsheetPhotoURL
  extend ActiveSupport::Concern

  # class to hold URL information
  class ImageURLData
    NON_FLICKR_URL_BASE = "http://openn.library.upenn.edu/html/pop_pictures"

    attr_accessor :url_or_filename

    def initialize url_or_filename
      @url_or_filename = url_or_filename
    end

    def flickr?
      url_or_filename =~ /flickr\.com/
    end

    def live?
      begin
        open image_url
        true
      rescue OpenURI::HTTPError
        false
      end
    end

    def flickr_id
      return unless flickr?
      @flickr_id ||= url_or_filename.strip.split('/').pop
    end

    def image_url
      return flickr_url if flickr?

      "#{NON_FLICKR_URL_BASE}/#{url_or_filename}"
    end

    def flickr_url
      # return the URL for the original image on Flickr
      client.url flickr_info, :url_o
    end

    def flickr_info
      # DO NOT cache flick info, it may change
      client.get_info flickr_id
    end

    def client
      @client ||= Flickr::Client.connect!
    end
  end

  def image_url_data url_or_filename
    ImageURLData.new url_or_filename
  end

  def non_flickr_url_base
    NON_FLICKR_URL_BASE
  end
end