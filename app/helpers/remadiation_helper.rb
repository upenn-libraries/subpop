module RemadiationHelper
  include FlickrHelper

  def publishable_link class_name:, id:
    publishable = find_publishable class_name: class_name, id: id
    link_to publishable.full_name, flickr_path(publishable)
  end

  def book_link class_name:, id:
    publishable ||= find_publishable class_name: class_name, id: id
    link_to publishable.book_full_name, publishable.book
  end

  def find_publishable class_name:, id:
    class_name.safe_constantize.find id
  end
end