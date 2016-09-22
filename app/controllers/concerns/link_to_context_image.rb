module LinkToContextImage
  extend ActiveSupport::Concern

  def link_to_context_image item, source_photo_id
    return unless item.respond_to? :context_image=
    item.context_image = get_context_image source_photo_id
  end

  def get_context_image source_photo_id
    return nil unless source_photo_id.present?

    photo = Photo.find source_photo_id
    return unless photo.book_id.present?

    @context_image = ContextImage.find_or_create_by! photo_id: photo.id, book_id: photo.book_id
  end

end