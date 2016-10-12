module FlickrData
  extend ActiveSupport::Concern

  def user_id
    Flickr::Client.flickr_userid
  end

  def info_obj
    # don't cache @info_obj if flickr_info is empty
    return Flickr::Info.new user_id if publication_data.blank?

    @info_obj ||= Flickr::Info.new(user_id, publication_data.metadata)
  end

  def respond_to_missing? method, include_private=false
    info_obj.respond_to?(method, include_private) || super
  end

  def method_missing method, *args, &block
    if info_obj.respond_to? method
      info_obj.send(method, *args, &block)
    else
      super
    end
  end

end