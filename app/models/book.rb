class Book < ActiveRecord::Base
  has_many :photos, dependent: :destroy
  has_many :title_pages, dependent: :destroy
  has_many :evidence, dependent: :destroy

  validates_presence_of :title
  accepts_nested_attributes_for :title_pages

  def full_name
    [ repository, call_number, vol_number ].flat_map { |s|
      s.present? ? s : []
    }.join ', '
  end

  def full_title
    [ title, vol_number ].flat_map { |s| s.present? ? s : [] }.join ', '
  end
  alias_method :name, :full_title

  def publication_info?
    [ creation_place, creation_date, publisher ].any? &:present?
  end

  def publication_info
    [ publisher, creation_place, creation_date ].flat_map { |s|
      s.present? ? s : []
    }.join ', '
  end
end
