class TitlePagesController < ApplicationController
  before_action :set_title_page,  only: [ :show, :destroy ]
  before_action :set_book,        only: [ :create, :destroy ]

  authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to @book, :alert => exception.message }
    end
  end

  def show
    respond_to do |format|
      format.html { redirect_to @title_page.book }
    end
  end

  def create
    @title_page = @book.title_pages.build title_page_params

    respond_to do |format|
      if @title_page.save_by current_user

        format.html { redirect_to @book, notice: 'Added title page.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { redirect_to @book, notice: 'Error adding title page' }
        format.json { redirect_to json: @title_page.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @title_page.mark_deleted
    DeletePublishableJob.perform_later @title_page, current_user
    respond_to do |format|
      format.js
      format.html { redirect_to @book, notice: 'Title page was removed.' }
    end
  end

  private
  def title_page_params
    params.require(:title_page).permit(:photo_id, :book_id)
  end

  def set_title_page
    @title_page = TitlePage.find params[:id]
  end

  def set_book
    @book = Book.find params[:book_id]
  end
end
