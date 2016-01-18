class TitlePage < ActiveRecord::Base
  belongs_to :book

  has_attached_file :image,
    styles: {
       medium:   [ '800x800>',   :jpg ],
       thumb:    [ '190x190>',   :jpg ]
    }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  process_in_background :image, processing_image_url: "/images/:style/processing.png"

end
