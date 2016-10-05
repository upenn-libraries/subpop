##
# Module to be included in Publishable. Generates metadata for model object
# for publication to Flickr.
module FlickrMetadata
  extend ActiveSupport::Concern
  include FlickrData

  FLICKR_YES = 1
  FLICKR_NO  = 0

  TAG_ATTRS = %w(
    book.repository
    book.full_call_number
    book.owner
    book.collection
    book.author
    book.title
    book.creation_place
    book.creation_date
    book.publisher
    format_name
    content_types.name
    location_name
    year_when
    where
    provenance_agents.name.full_name
  )

  ##
  # Flickr's API method `flickr.photos.setMeta` accepts the title and
  # description. `metadata` returns a hash of these  values.
  def metadata
    {
      title: flickr_title,
      description: description
    }
  end

  ##
  # Return hash with values suitable for the Fickr `upload` call; by default
  # `metadatata` and the tags from the object. Values passed into
  # `options` will be merged into the resulting hash. If present, the keys
  # `:title`, `:description`, and `:tags` will override the default
  # values.
  #
  # See documentation of `Flickr::Client#upload` for valid options.
  def upload_data options={}
    metadata.merge({ tags: flickrize_tags(tags_from_object) }).merge(options)
  end

  def flickr_title
    what = if self.respond_to? :format_name
      format_name
    else
      # DE 2016-09-20 don't append ' image' to avoid 'Context image image'
      self.model_name.human
    end
    [ book_full_name, what ].join ': '
  end

  def tags_to_add
    # return all the tags not on Flickr
    tags_from_object - tags_on_flickr
  end

  def tags_to_remove
    # return all the tags on Flickr, no longer in the object
    tags_on_flickr - tags_from_object
  end

  def description
   ac = ActionController::Base.new()
   ac.render_to_string('/flickr/description',
    locals: { item: self, book: book })
  end

  def flickrize_tags tags
    tags.map { |t| "\"#{t.raw}\"" }.join ' '
  end

  def tags_from_object
    tag_strings = TAG_ATTRS.flat_map { |attr_chain|
      extract_tag(self, attr_chain) || []
    }

    tag_strings << context_image_tag

    tag_strings.compact.uniq.map { |s| Flickr::Tag.new(raw: s) }
  end

  def context_image_tag
    s = "Page context ID-%d"

    return sprintf(s, id) if is_a? ContextImage
    return                unless respond_to? :context_image
    return                unless context_image.present?
    return sprintf s, context_image_id
  end

  ##
  # Recursively extract the tag value(s) from `obj` using the
  # string of chained attributes `attrs`:
  #
  #   book.author         # => "Dickens, Charles"
  #   format_name         # => "Bookplate/Label"
  #   content_types.name  # => [ "Armorial", "Forgery" ]
  #
  # Returns `nil` when obj does not respond to the next attr in the chain;
  # that is, if `obj` does not have a method `foo` then processing
  # stops and `nil` is returned.
  def extract_tag obj, attrs
    # if there are no more attributes, return obj
    return obj                              if attrs.blank?

    # Process the next attribute in the chain and keep the rest
    curr_attr, remaining_attrs = attrs.split '.', 2
    # if curr_attr is not a method of obj, return nil
    return nil                              unless obj.respond_to? curr_attr
    # grab the next value
    val = obj.send(curr_attr)

    return nil                              if val.blank?
    return val.to_s                         if remaining_attrs.blank?
    return extract_tag val, remaining_attrs unless val.respond_to? :map
    # val must be a list, process each member
    val.map { |o| extract_tag o, remaining_attrs.dup }
  end
end