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
# Flickr informatino is stored in the PublicationData assocation. Each
# Publishable may have one PublicationData. Upon initial publication, a
# PublicationData object is created. It is then updated upon subsequent
# updates to Flickr; and deleted if an item is unpublished. Any item on Flickr
# should have an associated PublicationData instance.
##
module Publishable
  extend ActiveSupport::Concern
  include FlickrMetadata

  UNPUBLISHED = "unpublished"
  UP_TO_DATE  = "up-to-date"
  OUT_OF_DATE = "out-of-date"
  IN_PROCESS  = "in-process"

  included do
    has_one :publication_data, as: :publishable, inverse_of: :publishable,
      dependent: :destroy
    accepts_nested_attributes_for :publication_data

    delegate :updated_at,   to: :book,             prefix: true,  allow_nil: true
    delegate :updated_at,   to: :photo,            prefix: true,  allow_nil: true
    delegate :published_at, to: :publication_data, prefix: false, allow_nil: true
    delegate :flickr_id,    to: :publication_data, prefix: false, allow_nil: true
    delegate :full_name,    to: :book,             prefix: true,  allow_nil: true
    delegate :cropped?,     to: :photo,            prefix: true,  allow_nil: true

    scope :active, -> { where deleted: false }
  end

  def publish user_id, force: false
    return              unless force || publishable?

    # TODO: Changing to update_columns as a kludge in order to prevent
    # changing the timestamp. Need to add locking/in_process tracking to
    # different object.
    mark_in_process
    return publish_new user_id unless on_flickr?

    republish user_id
  end

  def publish_new user_id
    begin
      client   = Flickr::Client.connect!

      id       = client.upload(photo.image_data, upload_data)
      info     = client.get_info id

      self.publication_data ||= PublicationData.new publishable: self
      self.publication_data.assign_attributes flickr_id: id, metadata: info.to_json
      self.publication_data.save_by! User.find user_id
    ensure
      unmark_in_process
    end
  end

  def republish user_id
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

      self.publication_data.assign_attributes metadata: info.to_json
      self.publication_data.save_by! User.find user_id
    ensure
      unmark_in_process
    end
  end

  def on_flickr?
    # flickr_id is delegated to publication_data; flickr_id.present? returns
    # true only if publication_data and publication_data.flickr_id are present
    flickr_id.present?
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
    return if publishing_to_flickr? # already marked true

    update_columns publishing_to_flickr: true
  end

  def unmark_in_process
    return unless publishing_to_flickr? # already marked false

    update_columns publishing_to_flickr: false
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
  def delete_from_flickr user_id=nil
    return unless user_id.present?
    begin
      # DE - 2016-08-05 change delete_from_flickr behavior to clear flickr data;
      # previously, publication_data was deleted; changed to keep pub..n_data,
      # but clear flickr_id and metadata. #on_flickr? changed to report presence
      # of publication_data.flickr_id (handled by delegate; above)
      return unless on_flickr?

      client = Flickr::Client.connect!
      client.delete flickr_id
      # remove all the flickr data
      self.publication_data.clear_flickr_data
      self.publication_data.save_by! User.find user_id
    ensure
      unmark_in_process
    end
  end

  def mark_deleted
    update_attributes deleted: true
  end

  def unmark_deleted
    update_attributes deleted: false
  end

  ##
  # Return whether `last_updated` (see `#last_updated`) has changed since
  # publication. Always returns `true` if the flickr ID column is empty;
  # otherwise, returns true if `last_updated` timestamp is newer than
  # `published_at` timestamp plus one second.
  #
  # NOTES:
  #
  # Not sure whether this method always gives the desired result -- is it
  # possible that insignificant changes to the object will result in a repush?
  #
  # One second is added to the published_at time. The updated_at value for the
  # `Publishable` model will always be at least a few millisceconds after the
  # `published_at` value; as in this case, for example:
  #
  #     publishable.update_attributes published_at: DateTime.now
  #
  # MySQL has seconds precision for datetime values; however, it is possible
  # (about 2 times out of a thousand based on my crude tests) for updated_at to
  # be in the next second. Adding the second to published_at should catch those
  # cases.
  def changed_since_publication?
    return true unless on_flickr?

    last_updated > published_at + 1.second
  end

  ##
  # Return the latest `updated_at` for model, photo, or book.
  def last_updated
    [updated_at, book_updated_at, photo_updated_at].compact.max
  end
end