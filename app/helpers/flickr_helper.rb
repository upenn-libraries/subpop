module FlickrHelper

  def publishable_div_id item
    "publishable-#{item.model_name.element}-#{item.id}"
  end

end