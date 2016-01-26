class TitlePage < ActiveRecord::Base
  include Publishable
  include FlickrData

  belongs_to :book
  belongs_to :photo

end