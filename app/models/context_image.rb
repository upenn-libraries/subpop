class ContextImage < ActiveRecord::Base
  include Publishable
  include HasPhoto
  include UserFields

  belongs_to :book, required: true, inverse_of: :context_images

  delegate :full_name, to: :book, prefix: true, allow_nil: true

  def name
    return "context image" unless book_full_name.present?
    "context image of #{book_full_name}"
  end

  def to_s
    model_name.human
  end
end
