# Custom methods for form tag handling.
module SubpopFormTagHelper
  # Moving hint_tag handling into its own helper. Roughly parallels hint
  # methods in SubpopFormbuilder.

  def hint_tag obj, attribute, options={}
    val        = options[:hint_text] || hint_tag_text(obj, attribute, options)
    return if val == ''

    hint_class = options[:hint_class] || 'help-block'
    tag        = options[:hint_tag]   || :span

    # "<span class=\"help-block\">#{val}</span>"
    content_tag tag, val, class: hint_class
  end

  def hint_tag_text obj, attribute, options={}
    key = options[:hint_key] || hint_tag_key(obj, attribute)
    t hint_tag_key(obj, attribute), default: ''
  end

  def hint_tag_key obj, attribute, options={}
    "activerecord.hints.#{hint_tag_object_name obj}.#{attribute}"
  end

  def hint_tag_object_name obj
    return obj.model_name.element if obj.is_a? ActiveRecord::Base

    obj.to_s
  end
end