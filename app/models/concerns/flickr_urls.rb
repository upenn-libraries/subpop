module FlickrUrls
  extend ActiveSupport::Concern

  PHOTOSTREAM_URL = 'https://www.flickr.com/photos/'.freeze

  def photopage_url
    return nil if info_hash.blank?

    photostream_url + info_hash['id']
  end

  def photostream_url
    return nil if info_hash.blank?

    nsid = info_hash['owner']['nsid']
    PHOTOSTREAM_URL + nsid + '/'
  end
end