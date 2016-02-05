module FlickrData
  extend ActiveSupport::Concern

  PHOTOS_URL = 'https://www.flickr.com/photos/'.freeze

  def photopage_url
    "#{photostream_url}/#{info_hash['id']}"
  end

  def tag_url tag
    t = tag.kind_of?(String) ? Subpop::Tag.new(tag) : tag

    "#{photostream_url}/tag/#{t.normalize}"
  end

  def photostream_url
    return nil unless on_flickr?
    nsid = info_hash['owner']['nsid']

    "#{PHOTOS_URL}#{nsid}"
  end

  def on_flickr?
    flickr_info.present?
  end

  def info_hash
    @info_hash ||= (on_flickr? and JSON::load(flickr_info))
  end
end