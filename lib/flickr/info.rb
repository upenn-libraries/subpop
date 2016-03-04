module Flickr
  class Info
    attr_reader :info
    PHOTOS_URL = 'https://www.flickr.com/photos/'.freeze

    def initialize info=nil
      @info = case info
      when nil
        nil
      when Hash
        info
      when String
        JSON::load info
      end
    end

    # Generate the URL for this tag within the user's Flickr photostream. The
    # `flickr_tag` can be either a Flickr::Tag instance or a String
    def tag_url flickr_tag
      tag = flickr_tag.is_a?(Tag) ? flickr_tag : Tag.new(raw: flickr_tag)

      "#{photostream_url}/tags/#{tag.normalize}"
    end

    def tags_on_flickr
      return [] if @info.nil?
      return [] if @info['tags'].nil?
      @info['tags'].map { |data| Tag.new data }
    end

    def photostream_url
      "#{PHOTOS_URL}#{nsid}"
    end

    def photopage_url
      "#{photostream_url}/#{photo_id}"
    end

    def photo_id
      @info['id']
    end

    def nsid
      Flickr::Client.flickr_userid
    end

    def owner_data
      @info and @info['owner']
    end
  end
end