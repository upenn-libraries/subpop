module FlickrHelper

  def publishable_div_id item
    "publishable-#{item.model_name.element}-#{item.id}"
  end

  def flickr_path item
    case item
    when Evidence
      flickr_evidence_path item
    when TitlePage
      flickr_title_page_path item
    when Book
      flickr_book_path item
    when ContextImage
      flickr_context_image_path item
    end
  end

  def link_to_publish_evidence name, item, options={}
    if ! item.publishable?
      options[:disabled] = true
      options[:title]    = disabled_reason(item.flickr_status)

      name = 'Please wait...' if item.processing?
      path = '#'
    elsif item.on_flickr?
      options[:method] = :put
      path = flickr_evidence_path(item)
    else
      options[:method] = :post
      path = flickr_evidence_path(item)
    end

    link_to name, path, options
  end

  def link_to_publish_item name, item, options={}
    return link_to_publish_evidence(name,item,options) if item.is_a? Evidence
    if ! item.publishable?
      options[:disabled] = true
      options[:title]    = disabled_reason(item.flickr_status)

      name = 'Please wait...' if item.processing?
      path = '#'
    elsif item.on_flickr?
      options[:method]   = :put

      # path = update_flickr_item_path item_type: item.model_name.element, id: item
      path = flickr_path item
    else
      options[:method]   = :post

      # path = create_flickr_item_path item_type: item.model_name.element, id: item
      path = flickr_path item
    end

    link_to name, path, options
  end

  def link_to_publish_book name, book, options={}
    if book.processing?
      options[:disabled] = true
      options[:title]    = 'Processing; please wait...'
      name = "Please wait..."
      path = '#'
    elsif ! book.publishable?
      options[:disabled] = true
      options[:title]      = 'All book images up-to-date on Flickr.'
      path = '#'
    elsif book.on_flickr?
      options[:method] = :put

      path = flickr_book_path book
    else
      options[:method] = :post

      path = flickr_book_path book
    end

    link_to name, path, options
  end

  def link_to_unpublish_item name, item, options={}
    if ! item.unpublishable?
      options[:disabled] ||= true
      options[:title]    ||= disabled_reason(item.flickr_status)

      name = 'Please wait...' if item.processing?
      path = '#'
    else
      options[:method]   ||= :delete
      options[:data][:confirm] ||= 'Remove this image from Flickr?'

      #path = delete_flickr_item_path item_type: item.model_name.element, id: item
      path = flickr_path item
    end

    link_to name, path, options
  end

  def link_to_unpublish_book name, book, options={}
    if book.processing?
      options[:disabled] = true
      options[:title]    = 'Processing; please wait...'

      name = 'Please wait...' if book.processing?
      path = '#'
    elsif ! book.unpublishable?
      options[:disabled] = true
      options[:title]    = 'Book not published to Flickr'
      path = '#'
    else
      options[:method]   = :delete
      options[:data][:confirm] = "Remove all this book's images from Flickr?"

      path = flickr_book_path id: book
    end

    link_to name, path, options
  end


  def disabled_reason flickr_status
    return 'Processing; please wait...' if flickr_status == Publishable::IN_PROCESS
    return 'Item up-to-date'            if flickr_status == Publishable::UP_TO_DATE
    return 'Item not on Flickr'         if flickr_status == Publishable::UNPUBLISHED
  end

end