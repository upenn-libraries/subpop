require 'rails_helper'

# This spec tests the spe

shared_examples_for "spreadsheet_extractor" do
  let(:model) {  described_class }
  let(:new_object) { build model.to_s.underscore.to_sym }
  let(:created_object) { create model.to_s.underscore.to_sym }

  it 'opens a spreadsheet for an unsaved object' do
    expect(new_object.open_spreadsheet).to respond_to :read
  end

  it 'opens a spreadsheet for a saved object' do
    expect(created_object.open_spreadsheet).to respond_to :read
  end

  it 'get the workbook an unsaved object' do
    expect(new_object.workbook).to be_a RubyXL::Workbook
  end

  it 'gets the workbook for a saved object' do
    expect(created_object.workbook).to be_a RubyXL::Workbook
  end

  it 'extracts the spreadsheet data' do
    expect(new_object.spreadsheet_data).to be_an Array
  end

  it 'gets the heading column' do
    expect(new_object.heading_column).to eq 1
  end

  it 'gets the heading addresses' do
    expect(new_object.extract_heading_addresses).to be_a Hash
  end

  context 'nonprovenance' do

  end

  context 'provenance' do

  end
end
