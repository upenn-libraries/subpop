require 'rails_helper'

module Flickr
  RSpec.describe Info do

    let(:photo_json) { open(File.join(fixture_path, 'flickr_photo.json')).read }
    let(:photo_info) { JSON::load(photo_json) }

    subject(:info) { Info.new(photo_info) }

    context "initialize" do
      it "creates an Info object from a hash" do
        expect(Info.new(photo_json).info).to be_a Hash
      end

      it "creates an Info obect from a json string" do
        expect(Info.new(photo_json).info).to be_a Hash
      end

      it "creates an Info object with a nil #info" do
        expect(Info.new.info).to be_nil
      end

      it 'has an info hash' do
        expect(subject.info).to be_a Hash
      end
    end

    context "accessor methods" do
      it "has a photo ID" do
        expect(subject.photo_id).to eq("15019795936")
      end

      it 'has an nsid' do
        expect(subject.nsid).to eq('58558794@N07')
      end
    end

    context "urls" do
      it "creates a photostream URL" do
        # "#{PHOTOS_URL}#{nsid}"
        expect(info.photostream_url).to eq('https://www.flickr.com/photos/58558794@N07')
      end

      it "creates a photopage URL" do
        expect(subject.photopage_url).to eq('https://www.flickr.com/photos/58558794@N07/15019795936')
      end

      it 'creates a tag URL' do
        expect(subject.tag_url("tag value")).to eq('https://www.flickr.com/photos/58558794@N07/tag/tagvalue')
      end
    end
  end
end