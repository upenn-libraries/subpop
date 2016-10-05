class ContextImage < ActiveRecord::Base
  include Publishable
  include BelongsToPhoto
  include UserFields

  belongs_to :book, required: true, inverse_of: :context_images

  has_many :evidence, inverse_of: :context_image, dependent: :nullify

  delegate :full_name, to: :book, prefix: true, allow_nil: true

  scope :used, -> { active.where 'evidence_count > 0'}

  def name
    return "context image" unless book_full_name.present?
    "context image of #{book_full_name}"
  end

  def to_s
    model_name.human
  end
end
