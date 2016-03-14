class EvidenceContentType < ActiveRecord::Base
  belongs_to :evidence, touch: true
  belongs_to :content_type
end
