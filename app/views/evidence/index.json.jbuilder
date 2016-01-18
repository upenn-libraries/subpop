json.array!(@evidence) do |evidence|
  json.extract! evidence, :id, :book_id, :format, :content_type, :location_in_book, :location_in_book_page, :transcription, :year_when, :year_start, :year_end, :date_narrative, :where, :comments
  json.url evidence_url(evidence, format: :json)
end
