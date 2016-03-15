module ApplicationHelper

  def human_name obj, attr
    obj && obj.class.human_attribute_name(attr) || ''
  end

  NON_EVIDENCE_PHOTOS = [
                         [ 'Title page (not provenance evidence)', 'title_page' ],
                         [ 'Context image (not provenance evidence)', 'context_image' ]
                        ]

  PHOTO_ASSIGNMENTS = NON_EVIDENCE_PHOTOS + Evidence::FORMATS

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  ##
  # Returns a dasherized tag to add HTML id elements. For example, for an TitlePage object with `id` 6
  def html_id_tag obj
    "#{obj.class.name.underscore.dasherize}-#{obj.id}"
  end

  def bootstrap_class_for(flash_type)
    case flash_type
    when "success"
      "alert-success"   # Green
    when "error"
      "alert-danger"    # Red
    when "alert"
      "alert-warning"   # Yellow
    when "notice"
      "alert-info"      # Blue
    else
      flash_type.to_s
    end
  end

  ##
  # Using format the datetime string, by default output looks like this:
  #
  #   Mon 14 Mar 2016 4:00PM EDT
  #
  # Not really much use unless you're using the default format.
  #
  # TODO: If need, add options for canned date formats like `:long`, `:short`,
  # `:w3c`, etc.
  def format_datetime datetime, fmt="%a %d %b %Y %-l:%M%p %Z"
    datetime.strftime fmt
  end
end
