FactoryGirl.define do
  factory :content_type do
    sequence :name do |n|
       "Content #{n}"
    end
  end
end