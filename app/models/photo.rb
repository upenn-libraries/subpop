class Photo < ActiveRecord::Base

  belongs_to :book,           inverse_of: :photos

  # Join photo to self. A photo can belong to an original, and inversely an
  # original can have many derivatives.
  belongs_to :original,    class_name: 'Photo', inverse_of: :derivatives
  has_many   :derivatives, class_name: 'Photo', inverse_of: :original, foreign_key: :original_id, dependent: :nullify

  # We nullify here, when photos are deleted. This makes possible deleting an
  # entire book, which may choose to delete photos before evidence, etc.
  # Without :nullify a foreign key constraint will be violated when the photo
  # is deleted.
  has_many   :title_pages,    inverse_of: :photo, dependent: :nullify
  has_many   :evidence,       inverse_of: :photo, dependent: :nullify
  has_many   :context_images, inverse_of: :photo, dependent: :nullify

  # See config/initializers/paper_clip.rb for :url and :path
  has_attached_file :image,
    styles: {
       original: [ '1800x1800>', :jpg ],
       medium:   [ '800x800>',   :jpg ],
       small:    [ '400x400>',   :jpg ],
       thumb:    [ '190x190>',   :jpg ]
    }, convert_options: {
       thumb: "-quality 75 -strip"
    },
    preserve_files: false,
    path: Rails.configuration.x.subpop.paperclip_path,
    url: Rails.configuration.x.subpop.paperclip_url

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

  def cropped?
    book.blank?
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