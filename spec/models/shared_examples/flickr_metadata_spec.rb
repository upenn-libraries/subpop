require 'rails_helper'

shared_examples_for 'flickr_metadata' do
  let(:model) { described_class } # the class that includes the concern
  let(:item) { FactoryGirl.create(model.to_s.underscore.to_sym) }

  let(:photo_json) { open(File.join(fixture_path, 'flickr_photo_tags.json')).read }
  let(:photo_info) { JSON::load(photo_json) }

  def add_flickr_data item
    item.flickr_id = photo_info['id']
    item.flickr_info = photo_json
  end

  it "has a Flickr title" do
    expect(item.respond_to? :flickr_title).to be true
  end

  context 'tags' do
    it "has tags_from_object" do
      expect(item.tags_from_object).to include(Flickr::Tag.new(raw: item.book.title))
    end

    it "has tags from Flickr" do
      add_flickr_data item
      expect(item.tags_on_flickr).to include(Flickr::Tag.new(raw: item.book.title))
    end

    it 'has tags_to_remove' do
      add_flickr_data item
      expect(item.tags_to_remove).to include(Flickr::Tag.new(raw: "Not in object"))
    end

    it 'has tags_to_add' do
      new_tag = Flickr::Tag.new raw: "Not on Flickr"
      add_flickr_data item
      item.book.title = new_tag.raw
      expect(item.tags_to_add).to include(new_tag)
    end
  end
end