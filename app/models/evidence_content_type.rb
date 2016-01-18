class EvidenceContentType < ActiveRecord::Base
  belongs_to :evidence
  belongs_to :content_type
end
