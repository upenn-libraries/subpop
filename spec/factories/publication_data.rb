FactoryGirl.define do
  factory :publication_data do
    association :publishable, factory: :evidence
    flickr_id   "25367313472"
    metadata    IO.read(Rails.root.join 'spec', 'fixtures', 'flickr_photo.json')
  end

  factory :unassigned_publication_data, class: PublicationData do
    flickr_id   "25367313472"
    metadata    IO.read(Rails.root.join 'spec', 'fixtures', 'flickr_photo.json')
  end

end