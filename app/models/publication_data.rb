# PublicationData represents columns shared by all Publishable objects
# (Evidence,  TitlePage); columns include: flickr_id and metadata.
#
# The relationship between Publishable models and PublicationData is managed
# by the Publishable model concern.
class PublicationData < ActiveRecord::Base
  include UserFields
  # TODO add user fields?
  belongs_to :publishable, polymorphic: true, inverse_of: :publication_data

  validates :publishable, presence: true

  def published_at
    return if flickr_id.blank? # nil if not on flickr
    updated_at
  end

  def clear_flickr_data
    self.flickr_id = self.metadata = nil
  end
end