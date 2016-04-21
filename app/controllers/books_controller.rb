class BooksController < ApplicationController
  before_action :set_book, except: [ :new, :index, :create ]

  # GET /books
  # GET /books.json
  def index
    @books = Book.order("coalesce(repository, owner)").page params[:page]
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        if params[:image].present?
          params[:image].each do |image|
            @book.photos.create image: image
          end
        end
          format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update_attributes book_params
        if params[:image].present?
          params[:image].each do |image|
            @book.photos.create! image: image
          end
        end
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_title_page
    photo = Photo.find params[:photo_id]
    @title_page = TitlePage.new book: @book, photo: photo
    respond_to do |format|
      if @title_page.save
        format.html { redirect_to @book, notice: 'Add title page.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { redirect_to @book, notice: 'Error adding title page' }
        format.json { redirect_to json: @title_page.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:repository, :owner, :collection, :geo_location, :call_number, :catalog_url, :vol_number, :author, :title, :creation_place, :creation_date, :publisher)
    end
end
