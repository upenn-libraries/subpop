json.array!(@names) do |name|
  json.extract! name, :id, :name, :viaf_id
  json.label name.full_name
  json.value name.id
  json.url name_url(name, format: :json)
end
