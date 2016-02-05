require 'rails_helper'

module Flickr
  RSpec.describe Tag do
    context "initialize" do
      it "creates a Tag" do
        expect {
          Tag.new "tag string"
          }.not_to raise_error
      end
    end

    context "quoting" do
      it "quotes the string" do
        expect(Tag.new("tag string").quote).to eq('"tag string"')
      end

      it "single quotes the string" do
        expect(Tag.new("tag string").single_quote).to eq("'tag string'")
      end

      it "double quotes the string" do
        expect(Tag.new("tag string").double_quote).to eq('"tag string"')
      end

      it "cute quotes the string with ` and '" do
        expect(Tag.new("tag string").cute_quote).to eq("`tag string'")
      end
    end

    context "formatting" do
      it "leaves raw tags without spaces unchanged" do
        expect(Tag.new("mytag").flickr_format).to eq("mytag")
      end

      it "quote raw tags with spaces" do
        expect(Tag.new("my tag").flickr_format).to eq('"my tag"')
      end
    end

    context "normalize" do
      it "removes spaces" do
        expect(Tag.new("tag string").normalize).to eq("tagstring")
      end

      it "respects diacritics" do
        expect(Tag.new("münchen").normalize).to eq("münchen")
      end

      it "strips underscores" do
        expect(Tag.new("tag_string").normalize).to eq("tagstring")
      end

      it "strips punctuation" do
        expect(Tag.new("tag,;@!'\"?.string").normalize).to eq("tagstring")
      end
    end
  end
end