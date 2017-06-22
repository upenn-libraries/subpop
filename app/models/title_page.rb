class TitlePage < ActiveRecord::Base
  include Publishable
  include BelongsToPhoto
  include UserFields

  belongs_to :book, required: true, inverse_of: :title_pages

  delegate :full_name, to: :book, prefix: true, allow_nil: true

  def name
    return "title page" unless book_full_name.present?
    "title page of #{book_full_name}"
  end
  alias_method :full_name, :name

  def to_s
    model_name.human
  end
end