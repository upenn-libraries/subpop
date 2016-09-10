class Photo < ActiveRecord::Base

  belongs_to :book,           inverse_of: :photos

  has_many   :title_pages,    inverse_of: :photo
  has_many   :evidence,       inverse_of: :photo
  has_many   :context_images, inverse_of: :photo

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

  def has_book?
    book.present?
  end

  # Set the image from the base64-encoded url
  def data_url= url
    self.image = url
  end

  # No use in returning a data_url, but we don't want form fields to break for
  # lack of the attribute.
  def data_url
    nil
  end

  def orphaned?
    return false if book.present?
    !used?
  end

  # Return true if the photo is not a attached to a book and is associated
  # with less than 2 publishables.
  def isolated?
    return false if book.present?
    use_count < 2
  end

  def use_count
    evidence.count + title_pages.count + context_images.count
  end

  ##
  # Return false, unless the photo has been used for evidence, title page, or
  # context image.
  def used?
    return true unless evidence.empty?
    return true unless title_pages.empty?
    return true unless context_images.empty?
    false
  end
end