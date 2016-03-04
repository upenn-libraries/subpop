module Publishable
  extend ActiveSupport::Concern
  include FlickrMetadata

  included do
    before_destroy :delete_from_flickr
  end

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

    id     = client.upload(photo.image_data, upload_data)
    info   = client.get_info id
    update_attributes! flickr_id: id, flickr_info: info.to_json
  end

  def republish!
    client = Flickr::Client.connect!
    tags_to_remove.each do |tag|
      begin
        client.remove_tag tag
      rescue FlickRaw::FailedResponse => ex
        Rails.logger.warn "Unable to delete tag: #{tag}; reason #{ex}"
      end
    end
    client.set_tags flickr_id, flickrize_tags(tags_from_object)
    client.set_meta flickr_id, metadata
  end

  def delete_from_flickr
    if flickr_id.present?
      client = Flickr::Client.connect!
      client.delete flickr_id
      self.flickr_id = nil
      self.flickr_info = nil
      save!
    end
  end
end