module ApplicationHelper
  include SubpopFormTagHelper

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

  def link_to_add_fields(name, f, association, options={})
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end

    options[:class] ||= ""
    options[:class] += " add_fields"
    options[:data]  ||= {}
    options[:data].update id: id, fields: fields.gsub("\n", "")

    link_to(raw(name), '#', options)
  end

  def thumbnail_link_to item,path=nil
    return unless item.has_image?
    link_to thumbnail_image_tag(item), item.image.url(:original), target: '_blank',
      'data-toggle': 'tooltip', title: 'Click to open in new window'
  end

  def thumbnail_image_tag item
    return unless item.has_image?
    image_tag item.image.url(:thumb), class: 'img-thumbnail'
  end

  def parent_thumbnail_path parent, photo, options={}
    unless parent.persisted?
      parent_type = parent.model_name.plural
      return thumbnail_path photo, options.merge(parent_type: parent_type)
    end

    case parent
    when Book
      book_thumbnail_path          parent, photo, options
    when TitlePage
      title_page_thumbnail_path    parent, photo, options
    when Evidence
      evidence_thumbnail_path      parent, photo, options
    when ContextImage
      context_image_thumbnail_path parent, photo, options
    end
  end

  def link_to_delete_publishable book, item, options
    if item.processing?
      options[:disabled] = true
      options[:title]    = "Processing; please wait..."
      name = "Please wait..."
      path = '#'
    else
      format = item.publishable_format
      options[:data] ||= {}
      options[:data][:confirm] = "Delete this #{format}?"
      options[:method]         = :delete
      name = 'Delete'
      path = [book,item]
    end

    link_to name, path, options
  end

  ##
  # Returns a dasherized tag to add to HTML id elements. For example, for an
  # TitlePage object with `id` 6, will retrun `title-page-6`
  def html_id_for obj
    return '' if obj.nil?
    "#{obj.model_name.element.dasherize}-#{obj.id}"
  end

  def flickr_label_class flickr_status
    FLICKR_STATUS_LABEL_CLASSES[flickr_status] || "label-default"
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
    key = "activerecord.hints.#{obj.model_name.element}.#{attribute.to_s}"
    val = t key, default: ''
    return if val == ''

    raw "<span class=\"help-block\">#{val}</span>"
  end

  # We don't call this 'thumbnail' because bootstrap has a 'thumbnail' class.
  # A `thumb-container` is a `<div>` that contains a 'thumb` div, which
  # itself conatins the actual content.
  #
  # The ThumbnailsController returns an html fragment containing a `thumb`.
  # The `thumb` has `data` attributes that make possible finding it and its
  # corresponding `thumb-container`. These are
  #
  #   'data-parent':       ID of the parent Book, Evidence, TitlePage, etc.,
  #                        or 'new' if the parent has not been persisted
  #
  #   'data-parent-type':  plural underscore name of the parent; `books`,
  #                        'evidence', etc. ('evidence' is uninflected)
  #
  #   'data-thumbnail':    ID of the photo
  #
  #   'data-source-photo': [`thumb` only] ID of the original photo
  #
  # When an image is edited and a new photo created, we want to dynamically
  # display the new photo in the place of the one being replace. Since the new
  # photo will have a new ID, we can't use its ID to find the right parent
  # `thumb-container`. The `data-source-photo`, when present, is used to find
  # the correct `div`.
  #
  # Valid options:
  #
  #   `:source_photo`: source photo ID
  #
  def thumb_div parent, photo, options={}, &block
    attrs = {
      'class':            'thumb',
      'data-parent':      parent.id || 'new',
      'data-parent-type': parent.model_name.plural,
      'data-thumbnail':   photo.id,
      'data-source-photo': source_photo_id(options)
    }

    content_tag 'div', attrs do
      yield if block_given?
    end
  end

  def edit_photo_div parent, photo, options={}, &block
    attrs = {
      'class':              'edit-photo',
      'data-parent':        parent.id || 'new',
      'data-parent-type':   parent.model_name.plural,
      'data-thumbnail':     photo.id,
      'data-source-photo':  source_photo_id(options)
    }

    content_tag 'div', attrs do
      yield if block_given?
    end
  end

  def source_photo_id options={}
    return if options[:source_photo].blank?
    return options[:source_photo].id if options[:source_photo].is_a?(Photo)
    options[:source_photo]
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
  def format_datetime datetime, fmt="%F %H:%M %Z"
    return unless datetime.present?
    datetime.strftime fmt if datetime
  end

  # Use devis links outside of devise controllers:
  # http://stackoverflow.com/a/6393151
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def subpop_link_to_document document
    # TODO: Extract type and evidence; id: link to evidence
    # TODO: link_to(evidence.image.url(:thumb))
   #raw("<pre>#{Evidence.find(document.id.split.last).image.url(:thumb)}</pre>")
      Evidence.find(document.id.split.last).image.url(:thumb)

  end

  ##
  # Create select options for all users, marking as selected the options for
  # `username`. If `username` is `all`, 'All users' will be selected. If
  # `username` is `nil`, `current_user` will be selected.
  def user_filter_options username=nil
    user_list = User.by_name.map { |u| [u.username, u.username] }
    user_list.unshift ['All users', 'all']

    selected = get_user_filter username
    options_for_select user_list, selected
  end

  def get_user_filter username=nil
    return username.downcase if username.present?
    return 'all' unless user_signed_in?
    current_user.username
  end
end
