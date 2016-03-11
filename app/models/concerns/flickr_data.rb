module FlickrData
  extend ActiveSupport::Concern

  def on_flickr?
    flickr_info.present?
  end

  def info_obj
    # don't cache @info_obj if flickr_info is empty
    return Flickr::Info.new if flickr_info.blank?
    @info_obj ||= Flickr::Info.new(flickr_info)
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