class TitlePagesController < ApplicationController
  before_action :set_title_page, only: :show
  before_action :set_book, only: :create
  before_action :set_photo, only: :create

  def show
    respond_to do |format|
      format.html { redirect_to @title_page.book }
    end
  end

  def create
    @title_page = TitlePage.new book: @book, photo: @photo

    respond_to do |format|
      if @title_page.save
        @title_page.dequeue_photo
        format.html { redirect_to @book, notice: 'Added title page.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { redirect_to @book, notice: 'Error adding title page' }
        format.json { redirect_to json: @title_page.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_title_page
    @title_page = TitlePage.find params[:id]
  end

  def set_book
    @book = Book.find params[:book_id]
  end

  def set_photo
    @photo = Photo.find params[:photo_id]
  end
end
