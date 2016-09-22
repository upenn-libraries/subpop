class ContextImagesController < ApplicationController
  before_action :set_photo, only: :find_by_photo
  before_action :set_context_image, only: [:show, :destroy]
  before_action :set_book, only: [:destroy]

  authorize_resource only: [:show]

  def find_or_create_for_photo
  end

  def show
  end

  # DELETE /evidence/1
  # DELETE /evidence/1.json
  def destroy
    @context_image.save_by current_user
    @context_image.mark_deleted
    DeletePublishableJob.perform_later @context_image, current_user
    respond_to do |format|
      format.js
      format.html { redirect_to @book, notice: 'Context image was deleted.' }
    end
  end

  private
  def set_photo
    @photo = Photo.find params[:photo_id]
    @photo = @photo.original if @photo.cropped?
  end

  def set_context_image
    @context_image = ContextImage.find params[:id]
  end

  def set_book
    @book = Book.find params[:book_id]
  end
end