module FlickrUrls
  extend ActiveSupport::Concern

  PHOTOSTREAM_URL = 'https://www.flickr.com/photos/'.freeze

  def photopage_url
    return nil unless on_flickr?
    photostream_url + info_hash['id']
  end

  def photostream_url
    return nil unless on_flickr?
    nsid = info_hash['owner']['nsid']
    PHOTOSTREAM_URL + nsid + '/'
  end
end