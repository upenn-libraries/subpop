class Photo < ActiveRecord::Base
  include FlickrUrls

  belongs_to :book
  has_many :title_page_photos, dependent: :destroy
  has_many :evidence_photos, dependent: :destroy

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

  def image_data
    Paperclip.io_adapters.for(image)
  end

  def on_flickr?
    flickr_info.present?
  end

  def info_hash
    on_flickr? and JSON::load(flickr_info)
  end

end
