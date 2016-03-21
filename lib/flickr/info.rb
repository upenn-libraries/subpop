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

    SHORT_URL = 'https://flic.kr/p/'.freeze
    ##
    # Generate the short URL for Flickr. The `url_mod` can be one of:
    #
    #     `nil`   Return short URL for photo page [default]
    #     `"m"`   Small
    #     `"s"`   Square
    #     `"t"`   Thumbnail
    #     `"q"`   Large square
    #     `"n"`   Small 320
    def short_url url_mod=nil
      return nil if photo_id.blank?

      mod_string = url_mod.nil? ? '' : "_#{url_mod}.jpg"
      SHORT_URL + base58(photo_id) + mod_string
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

    private
    # base58 code below taken directly from FlickRaw. Here:
    #
    # <https://github.com/hanklords/flickraw/blob/master/lib/flickraw/api.rb>
    #
    # FlickRaw has a method for creating these URLs, but it depends on the
    # FlickRaw Response object, which I don't store, don't want to recreate or
    # depend on.
    #
    # There is another way to handle this: The info hash could be wrapped in a
    # class that uses method missing to extract hash values and pass that
    # wrapper to FlickRaw. This would probably work. This class could also
    # implement method missing and be handed to FlickRaw.
    BASE58_ALPHABET="123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ".freeze
    def base58(id)
      id = id.to_i
      alphabet = BASE58_ALPHABET.split(//)
      base = alphabet.length
      begin
        id, m = id.divmod(base)
        r = alphabet[m] + (r || '')
      end while id > 0
      r
    end
  end
end