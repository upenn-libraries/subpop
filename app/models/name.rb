class Name < ActiveRecord::Base

  validates_numericality_of :viaf_id, allow_nil: true

  scope :name_like, -> (name) { where("name like ?", name)}

  def full_name
    [ name, date_string ].flat_map { |x| x.blank? ? nil : x }.join ', '
  end

  def date_string
    years = [ year_start, year_end ]
    years.all?(&:blank?) ? nil : years.join('-')
  end

  def to_s
    name
  end
end
