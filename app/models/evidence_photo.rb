class EvidencePhoto < ActiveRecord::Base
  belongs_to :evidence
  belongs_to :photo
end
