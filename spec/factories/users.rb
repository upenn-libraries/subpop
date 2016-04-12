FactoryGirl.define do
  factory :user do
    sequence :email do |n|
       "smith#{n}@example.com"
    end
    password 'secretpassword'
  end
end