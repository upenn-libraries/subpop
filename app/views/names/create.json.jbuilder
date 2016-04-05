json.name do
  if @name.errors.present?
    json.errors @name.errors
    json.error_messages @name.errors.full_messages
    json.error_count_message "The form has #{pluralize(@name.errors.count, 'error')}."
  end
  json.model @name.model_name.param_key

end
