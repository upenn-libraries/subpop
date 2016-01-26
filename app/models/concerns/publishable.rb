module Publishable
  extend ActiveSupport::Concern

  FLICKR_YES = 1
  FLICKR_NO  = 0

  def publish!
    client = Subpop::FlickrClient.connect!

    id     = client.upload(photo.image_data, metadata)
    info   = client.get_info id
    update_attributes! flickr_id: id, flickr_info: info.to_json

    client = nil
  end

  handle_asynchronously :publish!

  def metadata
    {
      title: "The title: #{Time.now}",
      description: "The description #{Time.now}",
      is_public: FLICKR_YES
    }
  end
end