FactoryGirl.define do
  factory :provenance_agent do
    association :evidence
    association :name
    role 'owner'
 end
end
