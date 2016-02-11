class Evidence < ActiveRecord::Base
  include Publishable

  belongs_to :book
  belongs_to :photo

  has_many :evidence_content_types, dependent: :destroy
  has_many :content_types, through: :evidence_content_types
  accepts_nested_attributes_for :evidence_content_types, allow_destroy: true

  has_many :provenance_agents, dependent: :destroy
  has_many :names, through: :provenance_agents
  accepts_nested_attributes_for :provenance_agents, allow_destroy: true,
    reject_if: proc { |attributes| attributes['name_id'].blank? }

  validates_presence_of :book

  FORMATS = [
             [ 'Binding',                      'binding' ],
             [ 'Binding Waste',                'binding_waste' ],
             [ 'Bookplate/Label',              'bookplate_label' ],
             [ 'Drawing/Illumination',         'drawing_illumination' ],
             [ 'Inscription',                  'inscription' ],
             [ 'Other paste-in',               'other_paste_in' ],
             [ 'Stamp -- inked',               'stamp_inked' ],
             [ 'Stamp -- blind or embossed',   'stamp_blind_or_embossed' ],
             [ 'Stamp -- perforated',          'stamp_perforated' ],
             [ 'Wax Seal',                     'wax_seal' ],
             [ 'Other Format',                 'other_format' ],
            ]

  FORMATS_BY_CODE = FORMATS.inject({}) { |hash, pair|
    hash.merge(pair.last => pair.first)
  }

  LOCATIONS = [
    [ 'Front Cover',                'front_cover' ],
    [ 'Inside Front Cover',         'inside_front_cover' ],
    [ 'Front Endleaf',              'front_endleaf' ],
    [ 'Title Page',                 'title_page' ],
    [ 'Title Page, Verso',          'title_page_verso' ],
    [ 'Page, Folio, or Signature Number (Type In Manually)',
                                    'page_number' ],
    [ 'Insertion',                  'insertion' ],
    [ 'Back Endleaf',               'back_endleaf' ],
    [ 'Inside Back Cover',          'inside_back_cover' ],
    [ 'Back Cover',                 'back_cover' ],
    [ 'Spine',                      'spine' ],
    [ 'Head, Tail, Fore Edge',      'head_tail_fore_edge' ],
  ]

  LOCATIONS_BY_CODE = LOCATIONS.inject({}) { |hash, pair|
    hash.merge(pair.last => pair.first)
  }

  def format_name
    FORMATS_BY_CODE[self.format]
  end

  def location_name
    return location_in_book_page if location_in_book == 'page_number'
    LOCATIONS_BY_CODE[location_in_book]
  end

  def content_type_names
    content_types.map(&:name)
  end

  def evidence_summary
    [ format_name, content_type_names ].flat_map { |s|
      s.present? ? s : []
    }.join ', '
  end

  def has_date?
    [ year_when, year_start, year_end ].any? &:present?
  end

  def date_string
    return nil unless has_date?
    return year_when.to_s if year_when.present?
    [ year_start, year_end ].join '-'
  end
end