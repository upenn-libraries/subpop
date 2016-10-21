module CroppingHelper
  def link_to_crop_photo parent, photo, options
    text = options.delete(:link_name) || "Edit photo"
    options[:title] ||= text
    link_to text, crop_image_path(parent, photo), options
  end

  def crop_image_path parent, photo
    return new_parent_crop_image_path parent, photo unless parent.persisted?

    case parent
    when Book
      book_crop_image_path parent, photo
    when Evidence
      evidence_crop_image_path parent, photo
    when TitlePage
      title_page_crop_image_path parent, photo
    when ContextImage
      context_image_crop_image_path parent, photo
    end
  end

  def book_crop_image_path parent, photo
    return edit_cropping_book_photo_path parent, photo unless photo.used?

    # We can't change a photo already assigned to a Title Page or Evidence. If
    # the photo has been used, we have have to create a new photo after the
    # crop.
    new_cropping_book_photo_path parent, { source_photo_id: photo.id }
  end

  def evidence_crop_image_path parent, photo
    return edit_cropping_evidence_photo_path parent, photo if photo.isolated?

    new_cropping_evidence_photo_path parent, { source_photo_id: photo.id }
  end

  def context_image_crop_image_path parent, photo
    return edit_cropping_context_image_photo_path parent, photo if photo.isolated?

    new_cropping_context_image_photo_path parent, { source_photo_id: photo.id }
  end

  def title_page_crop_image_path parent, photo
    return edit_cropping_title_page_photo_path parent, photo if photo.isolated?

    new_cropping_title_page_photo_path parent, { source_photo_id: photo.id }
  end

  ##
  # If the parent is persisted, we have to create a new photo and then find
  # the div based on the parent type and the ID of the source photo.
  def new_parent_crop_image_path parent, photo
    attrs = {
      source_photo_id: photo.id,
      parent_type: parent.model_name.plural
    }

    new_cropping_photo_path attrs
  end

  def new_cropped_photo_reason parent, photo
    case parent
    when Book
      "This photo has alreedy been used #{photo.use_count} #{'time'.pluralize photo.use_count}."
    end
  end

  def use_count photo
    # return unless photo.used?
    "Used #{photo.use_count} #{'time'.pluralize photo.use_count}"
  end
end