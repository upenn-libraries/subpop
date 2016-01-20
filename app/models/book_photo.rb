class BookPhoto < ActiveRecord::Base
  belongs_to :book
  belongs_to :photo
end
