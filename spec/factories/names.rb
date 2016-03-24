FactoryGirl.define do
  factory :name do
    sequence :name do |n|
      "Smith#{n}, Jane"
   end
 end
end