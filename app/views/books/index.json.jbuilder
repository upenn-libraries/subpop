json.array!(@books) do |book|
  json.extract! book, :id, :repository, :owner, :collection, :geo_location, :call_number, :catalog_url, :vol_number, :author, :title, :creation_place, :creation_date, :publisher
  json.url book_url(book, format: :json)
end
