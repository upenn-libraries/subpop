class Flickr::PublishablesController < Flickr::BaseController
  before_action :set_book

  def show
    authorize! :read, @item

    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  private

  def set_book
    @item ||= get_item
    @book = Book.find @item.book_id # god only knows why i have to do this
  end

end
