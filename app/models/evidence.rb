class Evidence < ActiveRecord::Base
  # Temp storage for photo_id for new evidence
  attr_accessor :photo_id

  before_save :set_image

  belongs_to :book

  has_many :evidence_content_types, dependent: :destroy
  has_many :content_types, through: :evidence_content_types
  accepts_nested_attributes_for :evidence_content_types, allow_destroy: true

  has_many :provenance_agents, dependent: :destroy
  has_many :names, through: :provenance_agents
  accepts_nested_attributes_for :provenance_agents, allow_destroy: true,
    reject_if: proc { |attributes| attributes['name_id'].blank? }

  has_attached_file :image,
    styles: {
       medium:   [ '800x800>',   :jpg ],
       small:    [ '400x400>',   :jpg ],
       thumb:    [ '190x190>',   :jpg ]
    }, convert_options: {
       thumb: "-quality 75 -strip"
    },
    preserve_files: false

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_presence_of :book

  process_in_background :image, processing_image_url: "/images/:style/processing.png"

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
    LOCATIONS_BY_CODE[location_in_book]
  end

  private

  def set_image
    if photo_id.present?
      self.image = Photo.find(photo_id).image
    end
  end

end
