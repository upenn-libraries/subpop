class PhotosController < ApplicationController
  before_action :set_book
  before_action :set_photo, except: [:index]

  def index
    @photos = @book.photos.queued
    respond_to do |format|
      format.html { respond_to @book }
      format.js   { }
    end
  end

  # PATCH/PUT /book/1/photos/1
  # PATCH/PUT /book/1/photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @book, notice: 'Photo was successfully updated.' }
        format.json { render :show, status: :ok, location: [ @book ] }
        format.js   { render :index, status: :ok, location: [ @book ] }
      else
        format.html { redirect_to @book, alert: 'Unable to update photo' }
        format.json { render status: :unprocessable_entity }
        format.js   { }
      end
    end
  end

  private
  def set_photo
    @photo = Photo.find params[:id]
  end

  def set_book
    @book = Book.find params[:book_id]
  end

  def photo_params
    params.require(:photo).permit(:in_queue, :book_id)
  end
end
