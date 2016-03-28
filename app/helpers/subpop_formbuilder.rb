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