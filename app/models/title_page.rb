class TitlePage < ActiveRecord::Base
  include Publishable

  belongs_to :book
  belongs_to :photo

end