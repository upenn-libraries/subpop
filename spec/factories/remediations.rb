FactoryGirl.define do

  factory :remediation do
    problems {}
    spreadsheet File.new("#{Rails.root}/spec/fixtures/spreadsheets/Valid_Flickr_sheet.xlsx")
  end
end