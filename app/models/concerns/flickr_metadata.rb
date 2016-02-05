# Module to be included in Publishable. Generates metadata for model object
# for publication to Flickr.
module FlickrMetadata
  extend ActiveSupport::Concern

  FLICKR_YES = 1
  FLICKR_NO  = 0

  def metadata
    {
      title: flickr_title,
      description: description,
      tags: flickrize_tags,
      is_public: FLICKR_YES
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
    [ "TODO: add tags", "Other tag" ].map { |s| Flickr::Tag.new(s) }
  end
end