class Name < ActiveRecord::Base

  validates :name, presence: true
  validates :name, uniqueness: true

  validates_numericality_of :viaf_id, allow_nil: true, allow_blank: true

  scope :name_like, -> (name) { where("lower(name) like ?", name.downcase)}

  def full_name
    [ name, date_string ].flat_map { |x| x.present? ? x : [] }.join ', '
  end

  def date_string
    years = [ year_start, year_end ]
    years.all?(&:blank?) ? nil : years.join('-')
  end

  def to_s
    name
  end
end
