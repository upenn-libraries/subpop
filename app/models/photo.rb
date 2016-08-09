class Photo < ActiveRecord::Base

  attr_accessor :data_url
  attr_accessor :edit_master_image

  belongs_to :book, inverse_of: :photos

  has_attached_file :image,
    styles: {
       original: [ '1800x1800>', :jpg ],
       medium:   [ '800x800>',   :jpg ],
       small:    [ '400x400>',   :jpg ],
       thumb:    [ '190x190>',   :jpg ]
    }, convert_options: {
       thumb: "-quality 75 -strip"
    },
    preserve_files: false

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  process_in_background :image, processing_image_url: "/images/:style/processing.png"

  scope :queued, -> { where in_queue: true }
  scope :unqueued, -> { where in_queue: false }

  def image_data
    Paperclip.io_adapters.for(image)
  end

  def has_image?
    image.present?
  end
end