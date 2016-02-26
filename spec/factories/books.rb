# This will guess the User class
FactoryGirl.define do
  factory :book do
    title "My book title"
  end

  # This will use the User class (Admin would have been guessed)
  factory :complete_book, class: Book do
    repository     "Penn Manuscripts"
    collection     "Smith Colleciton"
    geo_location   "Philadelphia, PA"
    call_number    "BK 123"
    catalog_url    "http//example.com/bk123"
    vol_number     "1"
    author         "Dickens, Charles"
    title          "Great Expectations"
    creation_place "London"
    creation_date  "1873"
    publisher      "Fezziwig"
    other_id       "1234567"
    other_id_type  "bibid"
    sammelband     true
  end
end