##
# This concern is included in models that belong to a photo: Evidence,
# TitlePage, and ContextImage.
#
module HasPhoto
  extend ActiveSupport::Concern

  included do
    belongs_to :photo

    delegate :has_image?, to: :photo, prefix: false, allow_nil: true
    delegate :in_queue?,  to: :photo, prefix: true,  allow_nil: true
    delegate :has_book?,  to: :photo, prefix: true,  allow_nil: true
    delegate :image,      to: :photo, prefix: false, allow_nil: true
  end

  def dequeue_photo
    return unless photo.present?
    return unless photo_in_queue?
    return unless photo_has_book? # queue is meaningless otherwise

    # mark without changing timestamp
    photo.update_columns in_queue: false
  end

  def requeue_photo
    return unless photo.present?
    return     if photo_in_queue?
    return unless photo_has_book? # queue is meaningless otherwise

    # mark without changing timestamp
    photo.update_columns in_queue: true
  end
end