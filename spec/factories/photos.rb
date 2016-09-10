# This will guess the User class
FactoryGirl.define do

  factory :photo do
    image_file_name    'BS_185_178206.jpg'
    image_content_type 'image/jpeg'
    image_file_size    1060104
    association        :book
  end

  factory :actual_photo, class: Photo do
    image File.new("#{Rails.root}/spec/fixtures/images/BS_185_178207.jpg")
    association :book
  end
end
