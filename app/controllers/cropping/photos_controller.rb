require 'base64'

class Cropping::PhotosController < ApplicationController
  before_action :set_photo
  before_action :set_book, only: [:update]

  def create
  end

  def edit
    authorize! :update, @photo

    respond_to do |format|
      format.html { render layout: 'cropper' }
    end
  end

  def update
    @photo.assign_attributes photo_params

    # @photo.image = params[:photo][:data_url]
    @photo.image = @photo.data_url
    @photo.save

    respond_to do |format|
      format.html { redirect_to @book }
    end
  end

  def set_photo
    @photo = Photo.find params[:id]
  end

  def set_book
    @book = @photo.book
  end

  def photo_params
    params.require(:photo).permit(:data_url, :edit_master_image)
  end
end
