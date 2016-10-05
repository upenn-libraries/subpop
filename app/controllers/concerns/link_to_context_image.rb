module LinkToContextImage
  extend ActiveSupport::Concern

  ##
  # Link item to ContextImage if item responds to `:context_image=`.
  #
  # Use option `:no_clobber` to prevent reassignment.
  def link_to_context_image item, source_photo_id, options={}
    return unless item.respond_to? :context_image=
    return     if options[:no_clobber] && item.context_image.present?

    item.context_image = get_context_image source_photo_id
  end

  def get_context_image source_photo_id
    return nil unless source_photo_id.present?

    photo = Photo.find source_photo_id
    return unless photo.book_id.present?

    @context_image = ContextImage.find_or_create_by! photo_id: photo.id, book_id: photo.book_id
  end
end