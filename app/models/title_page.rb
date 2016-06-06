class TitlePage < ActiveRecord::Base
  include Publishable
  include HasPhoto

  belongs_to :book, required: true, inverse_of: :title_pages

  delegate :full_name, to: :book, prefix: true, allow_nil: true

  def name
    return "title page" unless book_full_name.present?
    "title page of #{book_full_name}"
  end

  def to_s
    model_name.human
  end
end