module Publishable
  extend ActiveSupport::Concern

  FLICKR_YES = 1
  FLICKR_NO  = 0

  def publish!
    client = Subpop::FlickrClient.connect!
    photos.each do |ph|
      flickr_id = client.upload(ph.image_data, metadata)
      # ph.flickr_id = flickr_id
      info = client.get_info flickr_id
      ph.update_attributes! flickr_id: flickr_id, flickr_info: info.to_json
    end
    client = nil
  end

  handle_asynchronously :publish!

  def metadata
    {
      title: "The title",
      description: "The description",
      is_public: FLICKR_YES
    }
  end
end