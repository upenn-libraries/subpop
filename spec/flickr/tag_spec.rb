require 'rails_helper'

module Flickr
  RSpec.describe Tag do

    let(:tag_data) { JSON::load(%q{    {
      "id": "130596540-24810167602-37659184",
      "author": "130616888@N02",
      "authorname": "popdevelopment",
      "raw": "Penn Libraries",
      "_content": "pennlibraries",
      "machine_tag": 0
    }}) }

    subject(:subject) { Tag.new tag_data }

    context "initialize" do
      it "creates a Tag" do
        expect {
          Tag.new raw: "tag string"
          }.not_to raise_error
      end

      it 'has an id' do
        expect(subject.id).to eq("130596540-24810167602-37659184")
      end

      it 'has an author' do
        expect(subject.author).to eq("130616888@N02")
      end

      it 'has an authorname' do
        expect(subject.authorname).to eq("popdevelopment")
      end

      it 'has _content' do
        expect(subject._content).to eq("pennlibraries")
      end

      it 'has machine_tag' do
        expect(subject.machine_tag).to eq(0)
      end

      it 'creates a tag from hash' do
        expect(Tag.new tag_data).to be_a Tag
      end
    end

    context "quoting" do
      it "quotes the string" do
        expect(Tag.new(raw: "tag string").quote).to eq('"tag string"')
      end

      it "single quotes the string" do
        expect(Tag.new(raw: "tag string").single_quote).to eq("'tag string'")
      end

      it "double quotes the string" do
        expect(Tag.new(raw: "tag string").double_quote).to eq('"tag string"')
      end

      it "cute quotes the string with ` and '" do
        expect(Tag.new(raw: "tag string").cute_quote).to eq("`tag string'")
      end
    end

    context "formatting" do
      it "leaves raw tags without spaces unchanged" do
        expect(Tag.new(raw: "tagstring").flickr_format).to eq("tagstring")
      end

      it "quote raw tags with spaces" do
        expect(Tag.new(raw: "tag string").flickr_format).to eq('"tag string"')
      end
    end

    context "normalize" do
      it "removes spaces" do
        expect(Tag.new(raw: "tag string  ").normalize).to eq("tagstring")
      end

      it "respects diacritics" do
        expect(Tag.new(raw: "münchen").normalize).to eq("münchen")
      end

      it "strips underscores" do
        expect(Tag.new(raw: "tag_string").normalize).to eq("tagstring")
      end

      it "strips punctuation" do
        expect(Tag.new(raw: "tag,;@!'\"?.string").normalize).to eq("tagstring")
      end
    end
  end
end