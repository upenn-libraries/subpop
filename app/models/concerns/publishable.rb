module Publishable
  extend ActiveSupport::Concern
  include FlickrMetadata

  def publish!
    client = Subpop::FlickrClient.connect!

    id     = client.upload(photo.image_data, metadata)
    info   = client.get_info id
    update_attributes! flickr_id: id, flickr_info: info.to_json

    client = nil
  end
  handle_asynchronously :publish!

end