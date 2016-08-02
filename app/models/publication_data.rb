class PublicationData < ActiveRecord::Base
  belongs_to :publishable, polymorphic: true, inverse_of: :publication_data

  alias_attribute :published_at, :updated_at
end
