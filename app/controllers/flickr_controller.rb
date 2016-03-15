class FlickrController < ApplicationController
  before_action :get_book
  before_action :get_item

  def show
    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  private
  def get_book
    @book = Book.find params[:book_id]
  end

  def get_item
    @item_type = params[:item_type]
    klass      = @item_type.camelize.constantize
    @item      = klass.find params[:id]
  end
end
