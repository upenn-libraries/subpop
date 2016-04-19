module ApplicationHelper

  def human_name obj, attr
    obj && obj.class.human_attribute_name(attr) || ''
  end

  NON_EVIDENCE_PHOTOS = [
                         [ 'Title page',        'title_page' ],
                         [ 'Remove from queue', 'unqueue'    ],
                       ]

  PHOTO_ASSIGNMENTS = [
    [ 'Evidence format', Evidence::FORMATS   ],
    [ 'Non-evidence',    NON_EVIDENCE_PHOTOS ],
  ]

  FLICKR_STATUS_LABEL_CLASSES = {
    Publishable::UNPUBLISHED => "label-warning",
    Publishable::UP_TO_DATE  => "label-success",
    Publishable::OUT_OF_DATE => "label-danger",
    Publishable::IN_PROCESS  => "label-info"
  }

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

  def flickr_label_class flickr_status
    FLICKR_STATUS_LABEL_CLASSES[flickr_status] || "label-default"
  end

  def unpublishable_reason flickr_status
    return "Publishing; please wait ..." if flickr_status == Publishable::IN_PROCESS
    return "Item is up-to-date."         if flickr_status == Publishable::UP_TO_DATE
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

  def hint_text_tag obj, attribute
    obj  = obj.object if obj.kind_of? ActionView::Helpers::FormBuilder
    key = "activerecord.hints.#{obj.class.name.underscore}.#{attribute.to_s}"
    val = t key, default: ''
    return if val == ''

    raw "<span class=\"help-block\">#{val}</span>"
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
  def format_datetime datetime, fmt="%a %F %H:%M %Z"
    datetime.strftime fmt if datetime
  end
end
