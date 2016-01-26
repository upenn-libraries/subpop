# Module to be included in Publishable. Generates metadata for model object
# for publication to Flickr.
module FlickrMetadata
  extend ActiveSupport::Concern

  FLICKR_YES = 1
  FLICKR_NO  = 0

  def metadata
    {
      title: "The title: #{Time.now}",
      description: "The description #{Time.now}",
      is_public: FLICKR_YES
    }
  end
end