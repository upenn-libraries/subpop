##
# This concern manages the including model's presence on Flickr:
#
# - initial publication of the object's photo, tags, and metadata;
# - subsequent updates to the tag and metadata; and
# - deletion of the photo from Flickr.
#
# Including models should belong to a Photo and have these attributes:
# `flickr_id`, `flickr_info`, and `published_at`.
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
    update_attributes! flickr_id: id, flickr_info: info.to_json, published_at: Time.now
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
    info = client.get_info id
    update_attributes! flickr_info: info.to_json, published_at: Time.now
  end

  ##
  # Delete the photo from flickr and nullify the Flickr attributes
  # `flickr_id`, `flickr_info`, and `published_at`.
  #
  # **Does not save the attribute changes.** Caller must save or destroy the
  # model object.
  def delete_from_flickr
    if flickr_id.present?
      client = Flickr::Client.connect!
      client.delete flickr_id
      # remove all the flickr data
      assign_attributes flickr_id: nil, flickr_info: nil, published_at: nil
    end
  end

end