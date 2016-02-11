# Module to be included in Publishable. Generates metadata for model object
# for publication to Flickr.
module FlickrMetadata
  extend ActiveSupport::Concern

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

  def metadata
    {
      title: flickr_title,
      description: description,
      tags: flickrize_tags
    }
  end

  def flickr_title
    what = if kind_of? Evidence
      format_name
    else
      "#{self.class.underscore.humanize} image"
    end
    [ book.full_name, what ].join ': '
  end


  def description
   ac = ActionController::Base.new()
   ac.render_to_string('/flickr/description',
    locals: { item: self, book: book })
  end

  def flickrize_tags
    tags.map { |s| "\"#{s}\"" }.join ' '
  end

  def tags
    tag_strings = TAG_ATTRS.flat_map { |attr_chain|
      extract_tag(self, attr_chain) || []
    }

    tag_strings.uniq.map { |s| Flickr::Tag.new(raw: s) }
  end

  # Recursively extract the tag value(s) from ++obj++ using the
  # string of chained attributes ++attrs++:
  #
  #   book.author         # => "Dickens, Charles"
  #   format_name         # => "Bookplate/Label"
  #   content_types.name  # => [ "Armorial", "Forgery" ]
  #
  # Returns ++nil++ when obj does not respond to the next attr in the chain;
  # that is, if ++obj++ does not have a method ++foo++ then processing
  # stops and ++nil++ is returned.
  def extract_tag obj, attrs
    # if there are no more attributes, return obj
    return obj                              if attrs.blank?

    # Process the next attribute in the chain and keep the rest
    curr_attr, remaining_attrs = attrs.split '.', 2
    # if curr_attr is not a method of obj, return nil
    return nil?                             unless obj.respond_to? curr_attr
    # grab the next value
    val = obj.send(curr_attr)

    return nil                              if val.blank?
    return val.to_s                         if remaining_attrs.blank?
    return extract_tag val, remaining_attrs unless val.respond_to? :map
    # val must be a list, process each member
    val.map { |o| extract_tag o, remaining_attrs.dup }
  end
end