class Name < ActiveRecord::Base

  validates_numericality_of :viaf_id, allow_nil: true

  def to_s
    name
  end
end
