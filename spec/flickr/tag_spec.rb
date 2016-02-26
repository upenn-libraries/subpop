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

      it 'raises an error for bad options' do
        expect {
          Tag.new "not_an_option" => "Not an option", "_contentx" => "Content x"
        }.to raise_error ArgumentError
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

    context 'text' do
      it "returns normalize if _content not defined" do
        expect(Tag.new(raw: "my tag").text).to eq("mytag")
      end

      it 'returns _content if it is defined' do
        expect(Tag.new(raw: "my tag", _content: "othervalue").text).to eq("othervalue")
      end
    end

    context 'equals' do
      it 'says two tags are equal if the raw is the same' do
        expect(Tag.new raw: 'a').to eq(Tag.new(raw: 'a'))
      end

      it 'says two tags are equal if the content equals the text' do
        expect(Tag.new _content: 'a').to eq(Tag.new raw: 'a')
      end

      it 'says a flickr tag equals an ad hoc tag' do
        expect(subject).to eq(Tag.new raw: 'Penn Libraries')
      end
    end

    context 'tag sets' do
      it 'subtracts one set from another' do
        a  = Tag.new raw: 'a'
        b  = Tag.new raw: 'b'
        # We want two distinct tags that are equivalent
        c1 = Tag.new raw: 'c'
        c2 = Tag.new raw: 'c'
        d  = Tag.new raw: 'd'
        set1 = [ a, b, c1 ]
        set2 = [ c2, d ]
        expect(set1 - set2).to eq([ a, b ])
      end
    end
  end
end