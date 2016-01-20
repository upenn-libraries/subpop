class Book < ActiveRecord::Base
  has_many :book_photos, dependent: :destroy
  has_many :photos, through: :book_photos
  has_many :title_pages, dependent: :destroy
  has_many :evidence, dependent: :destroy

  validates_presence_of :title
  accepts_nested_attributes_for :title_pages

  def full_name
    [ repository, call_number, vol_number ].flat_map { |x| x || [] }.join ' '
  end

  def name
    [ title, vol_number ].flat_map { |x| x.present? ? x : [] }.join ', '
  end
end
