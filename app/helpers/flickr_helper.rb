module FlickrHelper

  def publishable_div_id item
    "publishable-#{item.model_name.element}-#{item.id}"
  end

  def publish_item_link name, item, options={}
    if ! item.publishable?
      options[:disabled] = true
      options[:title]    = disabled_reason(item.flickr_status)

      name = 'Please wait...' if item.processing?
      path = '#'
    elsif item.on_flickr?
      options[:method]   = :put

      path = update_flickr_item_path item_type: item.model_name.element, id: item
    else
      options[:method]   = :post

      path = create_flickr_item_path item_type: item.model_name.element, id: item
    end

    link_to name, path, options
  end

  def publish_book_link name, book, options={}
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

      path = update_flickr_book_path book
    else
      options[:method] = :post

      path = create_flickr_book_path book
    end

    link_to name, path, options
  end

  def unpublish_item_link name, item, options={}
    if ! item.unpublishable?
      options[:disabled] ||= true
      options[:title]    ||= disabled_reason(item.flickr_status)

      name = 'Please wait...' if item.processing?
      path = '#'
    else
      options[:method]   ||= :delete
      options[:data][:confirm] ||= 'Remove this image from Flickr?'

      path = delete_flickr_item_path item_type: item.model_name.element, id: item
    end

    link_to name, path, options
  end

  def unpublish_book_link name, book, options={}
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

      path = delete_flickr_book_path id: book
    end

    link_to name, path, options
  end


  def disabled_reason flickr_status
    return 'Processing; please wait...' if flickr_status == Publishable::IN_PROCESS
    return 'Item up-to-date'            if flickr_status == Publishable::UP_TO_DATE
    return 'Item not on Flickr'         if flickr_status == Publishable::UNPUBLISHED
  end

end