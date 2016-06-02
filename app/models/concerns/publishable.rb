##
# This concern manages the including model's presence on Flickr:
#
# - initial publication of the object's photo, tags, and metadata;
# - subsequent updates to the tag and metadata; and
# - deletion of the photo from Flickr.
#
# Including models should belong to a Photo and have these attributes:
# `book_id`, `book` `flickr_id`, `flickr_info`, `published_at`, and
# `publishing_to_flickr`.
#
# TODO: Consider creating a model PhotoInfo for connecting the photo to the
# model and contain Flickr information shared by Evidence, TitlePage, and
# Context (if it ever exists). This model would be then be managed by the
# Publishable Concern.
module Publishable
  extend ActiveSupport::Concern
  include FlickrMetadata

  UNPUBLISHED = "unpublished"
  UP_TO_DATE  = "up-to-date"
  OUT_OF_DATE = "out-of-date"
  IN_PROCESS  = "in-process"

  included do
    before_destroy :delete_from_flickr
    delegate :updated_at, to: :book, prefix: true, allow_nil: true
    scope :active, -> { where deleted: false }
  end

  def publish!
    return              unless publishable?

    # TODO: Changing to update_columns as a kludge in order to prevent
    # changing the timestamp. Need to locking/in_process tracking to different
    # object.
    update_columns publishing_to_flickr: true
    return publish_new! unless on_flickr?

    republish!
  end

  def publish_new!
    begin
      client = Flickr::Client.connect!

      id     = client.upload(photo.image_data, upload_data)
      info   = client.get_info id
      update_attributes! flickr_id: id, flickr_info: info.to_json,
        published_at: DateTime.now
    ensure
      update_columns publishing_to_flickr: false
    end
  end

  def republish!
    begin
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
    ensure
      update_columns publishing_to_flickr: false
    end
  end

  ##
  # Returns `true` if the item can be removed from Flickr; specifically if the
  # item's Flickr status is `UP_TO_DATE` or `OUT_OF_DATE`.  Items with status
  # `IN_PROCESS` and `UNPUBLISHED` cannot be removed from Flickr.
  def unpublishable?
    [ UP_TO_DATE, OUT_OF_DATE ].include? flickr_status
  end

  ##
  # Returns `true` if the Flickr status of the model is `UNPUBLISHED` or
  # `OUT_OF_DATE`.
  #
  def publishable?
    [ UNPUBLISHED, OUT_OF_DATE ].include? flickr_status
  end

  def mark_in_process
    update_columns publishing_to_flickr: true unless publishing_to_flickr?
  end

  def unmark_in_process
    update_columns publishing_to_flickr: false if publishing_to_flickr?
  end

  def publishable_format
    if respond_to? :format_name
      format_name
    else
      "#{model_name.human}"
    end
  end

  ##
  # Returns the current flickr status of the model, one of:
  #
  # - Publishable::UNPUBLISHED
  # - Publishable::UP_TO_DATE
  # - Publishable::OUT_OF_DATE
  # - Publishable::IN_PROCESS
  def flickr_status
    return IN_PROCESS  if publishing_to_flickr?
    return UNPUBLISHED unless on_flickr?
    return OUT_OF_DATE if changed_since_publication?

    UP_TO_DATE
  end

  def processing?
    flickr_status == IN_PROCESS
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

  def mark_deleted
    update_attributes deleted: true
  end

  def unmark_deleted
    update_attributes deleted: false
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