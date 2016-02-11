module Publishable
  extend ActiveSupport::Concern
  include FlickrMetadata
  include FlickrData


  def publish!
    if flickr_id.present?
      republish!
    else
      publish_new!
    end
  end
  handle_asynchronously :publish!

  def publish_new!
    client = Flickr::Client.connect!

    id     = client.upload(photo.image_data, metadata)
    info   = client.get_info id
    update_attributes! flickr_id: id, flickr_info: info.to_json

    client = nil
  end

  def republish!
    client = Flickr::Client.connect!

    client.set_tags flickr_id, flickrize_tags

    client = nil
  end

end