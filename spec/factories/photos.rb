# This will guess the User class
FactoryGirl.define do
  factory :photo do
    image_file_name    'BS_185_178206.jpg'
    image_content_type 'image/jpeg'
    image_file_size    1060104

    association        :book
 end
end
