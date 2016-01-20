class TitlePage < ActiveRecord::Base
  belongs_to :book
  has_many :title_page_photos, dependent: :destroy
  has_many :photos, through: :title_page_photos

end
