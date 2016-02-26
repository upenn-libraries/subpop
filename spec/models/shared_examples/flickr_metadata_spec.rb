require 'rails_helper'

shared_examples_for 'flickr_metadata' do
  let(:model) { described_class } # the class that includes the concern

  it "has a Flickr title" do
    item = FactoryGirl.create(model.to_s.underscore.to_sym)
    expect(item.respond_to? :flickr_title).to be true
  end
end