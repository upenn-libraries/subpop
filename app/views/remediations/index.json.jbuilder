json.array!(@remediations) do |remediation|
  json.extract! remediation, :id, :problems, :created_by_id, :updated_by_id
  json.url remediation_url(remediation, format: :json)
end
