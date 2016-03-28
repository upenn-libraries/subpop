class SubpopFormbuilder < ActionView::Helpers::FormBuilder

  def text_field attribute, options={}
    super + hint(attribute, options)
  end

  def select attribute, choices=nil, options={}, html_options={}
    super + hint(attribute, options)
  end

  def text_area attribute, options={}
    super + hint(attribute, options)
  end

  def number_field method, options={}
    super + hint(method, options)
  end

  def collection_check_boxes attribute, collection, value_method, text_method, options={}, html_options={}
    super + hint(attribute, options)
  end

  def check_box, attribute, options={}, checked_value = "1", unchecked_value = "0"
    super + hint(attribute, options)
  end

  def color_field, attribute, options={}
    super + hint(attribute, options)
  end

  def date_field, attribute, options={}
    super + hint(attribute, options)
  end

  def datetime_field, attribute, options={}
    super + hint(attribute, options)
  end

  def datetime_local_field, attribute, options={}
    super + hint(attribute, options)
  end

  def email_field, attribute, options={}
    super + hint(attribute, options)
  end

  def file_field, attribute, options={}
    super + hint(attribute, options)
  end

  def month_field, attribute, options={}
    super + hint(attribute, options)
  end

  def password_field, attribute, options={}
    super + hint(attribute, options)
  end

  def phone_field, attribute, options={}
    super + hint(attribute, options)
  end

  def radio_button, attribute, tag_value, options={}
    super + hint(attribute, options)
  end

  def range_field, attribute, options={}
    super + hint(attribute, options)
  end

  def search_field, attribute, options={}
    super + hint(attribute, options)
  end

  def telephone_field, attribute, options={}
    super + hint(attribute, options)
  end

  def time_field, attribute, options={}
    super + hint(attribute, options)
  end

  def url_field, attribute, options={}
    super + hint(attribute, options)
  end

  def week_field, attribute, options={}
    super + hint(attribute, options)
  end

  def hint attribute, options={}
    val        = options[:hint_text]  || hint_text(attribute, options)
    return unless val.present?

    hint_class = options[:hint_class] || 'help-block'
    tag        = options[:hint_tag]   || :span

    # "<span class=\"help-block\">#{val}</span>"
    @template.content_tag tag, val, class: hint_class
  end

  def hint_text attribute, options={}
    key = options[:hint_key] || "activerecord.hints.#{@object_name}.#{attribute}"
    I18n.t key, default: ''
  end
end