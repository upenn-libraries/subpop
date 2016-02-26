# This will guess the User class
FactoryGirl.define do
  factory :evidence do
    format 'bookplate_label'
    book
  end

  factory :evidence_on_flickr, class: Evidence do
    format 'bookplate_label'
    year_when 1874
    location_in_book 'front_endleaf'

    book
  end
end