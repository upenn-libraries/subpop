class Name < ActiveRecord::Base

  validates_numericality_of :viaf_id, allow_nil: true

  scope :name_like, -> (name) { where("name like ?", name)}

  def to_s
    name
  end
end
