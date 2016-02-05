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

    context "modification" do
      it "quotes the string" do
        expect(Tag.new("tag string").quote).to eq("`tag string'")
      end

      it "single quotes the string" do
        expect(Tag.new("tag string").squote).to eq("'tag string'")
      end

      it "double quotes the string" do
        expect(Tag.new("tag string").dquote).to eq('"tag string"')
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