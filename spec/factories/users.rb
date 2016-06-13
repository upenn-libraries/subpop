FactoryGirl.define do
  factory :user do
    sequence :username do |n|
      "smith#{n}"
    end
    sequence :email do |n|
       "smith#{n}@example.com"
    end
    password 'secretpassword'
    password_confirmation "secretpassword"
  end
end