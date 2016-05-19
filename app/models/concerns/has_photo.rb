##
# This concern is included in models that belong to a photo: Evidence, Title
# Page, and (future) Context Image.
#
module HasPhoto
  extend ActiveSupport::Concern

  included do
    belongs_to :photo
  end
end