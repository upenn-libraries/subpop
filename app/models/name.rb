class Name < ActiveRecord::Base
  include UserFields

  before_destroy :check_counter_cache

  has_many :provenance_agents

  validates :name, presence: true
  validates :name, uniqueness: true

  validates_numericality_of :viaf_id,    allow_nil: true, allow_blank: true
  validates_numericality_of :year_start, allow_nil: true, allow_blank: true
  validates_numericality_of :year_end,   allow_nil: true, allow_blank: true

  scope :name_like, -> (name) { where("lower(name) like ?", name.downcase) }

  GENDER = [
    ['Female', 'female'],
    ['Male',  'male'],
    ['Other', 'other'],
  ]

  GENDER_BY_CODE = GENDER.inject({}) { |hash, pair|
    hash.merge(pair.last => pair.first)
  }

  validates :gender, inclusion: { in: GENDER.map(&:last), message: "'%{value}' is not in list", allow_blank: true }

  def full_name
    return name if name_has_date?
    return name unless date_string.present?

    [ name, date_string ].flat_map { |x| x.present? ? x.strip : [] }.join ', '
  end

  def date_string
    years = [ year_start, year_end ]
    years.all?(&:blank?) ? nil : years.join('-')
  end

  def name_has_date?
    name =~ /^[[:alnum:]]+.*\d{4}/
  end

  def to_s
    name
  end

  private
  def check_counter_cache
    # proceed with destroy if provenance_agents is 0
    return true if provenance_agents.size == 0
    # otherwise, there's a problem
    errors[:base] << "Cannot delete name with provenance agents"
    false
  end
end
