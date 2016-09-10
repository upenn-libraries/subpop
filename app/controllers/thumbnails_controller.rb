class ThumbnailsController < ApplicationController
  include PolymorphicParent

  before_action :set_thumbnail
  before_action :set_or_create_parent
  before_action :set_parent_type
  before_action :set_source_photo

  def show
    respond_to do |format|
      format.js {
        if @thumbnail.image_processing?
          render format: :js, template: '/thumbnails/processing'
        else
          render fomat: :js
        end
      }
      format.json
    end
  end

  private

  def set_thumbnail
    @thumbnail = Photo.find params[:id]
  end

  def set_source_photo
    return unless params[:source_photo_id].present?

    @source_photo = Photo.find params[:source_photo_id]
  end

end