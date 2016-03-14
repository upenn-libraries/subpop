##
# This concern manages the including model's presence on Flickr:
#
# - initial publication of the object's photo, tags, and metadata;
# - subsequent updates to the tag and metadata; and
# - deletion of the photo from Flickr.
#
# Including models should belong to a Photo and have these attributes:
# `book_id`, `book` `flickr_id`, `flickr_info`, and `published_at`.
module Publishable
  extend ActiveSupport::Concern
  include FlickrMetadata

  included do
    before_destroy :delete_from_flickr
    delegate :updated_at, to: :book, prefix: true, allow_nil: true
  end

  def publish!
    if flickr_id.blank?
      publish_new!
    elsif changed_since_publication?
      republish!
    end
  end

  def publish_new!
    client = Flickr::Client.connect!

    id     = client.upload(photo.image_data, upload_data)
    info   = client.get_info id
    update_attributes! flickr_id: id, flickr_info: info.to_json,
      published_at: DateTime.now
  end
  handle_asynchronously :publish_new!

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
    info = client.get_info flickr_id
    update_attributes! flickr_info: info.to_json, published_at: DateTime.now
  end
  handle_asynchronously :republish!

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

  ##
  # Returns whether model or book has changed since publication. Always
  # returns `true` if the flickr ID column is empty; otherwise, returns true
  # if the model's or book's update timestamp is newer than the publication
  # timestamp plus one second.
  #
  # Not sure whether this method always gives the desired result -- is it
  # possible that insignificant changes to the object will result in a repush
  # or that?
  #
  # Note that 1 second is added to the published_at time. The update_at value
  # for the `Publishable` model will always be at least a few millisceconds
  # after the `published_at` value; as in this case, for example:
  #
  #     publishable.update_attributes published_at: DateTime.now
  #
  # MySQL has seconds precision for datetime values; however, it is possible
  # (about 2 times out of a thousand based on my crude tests) for updated_at to
  # be in the next second. Adding the second to published_at should catch those
  # cases.
  def changed_since_publication?
    return true if flickr_id.blank?

    last_updated > published_at + 1.second
  end

  # Returns either the book's updated_at value or the publishable model's
  # updated_at value, which ever is later.
  def last_updated
    return updated_at       if book_updated_at.blank?
    return book_updated_at  if book_updated_at > updated_at

    updated_at
  end
end