# PublicationData represents columns shared by all Publishable objects
# (Evidence,  TitlePage); columns include: flickr_id and metadata.
#
# The relationship between Publishable models and PublicationData is managed
# by the Publishable model concern.
class PublicationData < ActiveRecord::Base
  include UserFields
  # TODO add user fields?
  belongs_to :publishable, polymorphic: true, inverse_of: :publication_data

  alias_attribute :published_at, :updated_at

  validates :publishable, presence: true
end
