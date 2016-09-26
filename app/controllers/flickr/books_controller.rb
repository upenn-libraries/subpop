class Flickr::BooksController < Flickr::BaseController
   def create
    authorize! :update, @item

    respond_to do |format|
      create_publish_jobs
      format.js
      format.html { redirect_to @item, notice: "Publishing all book images" }
    end
  end

  def update
    authorize! :update, @item

    respond_to do |format|
      create_publish_jobs
      format.js
      format.html { redirect_to @item, notice: "Publishing all book images" }
    end
  end

  def destroy
    authorize! :update, @item

    respond_to do |format|
      create_unpublish_jobs
      format.js
      format.html
    end
  end

  def status
    authorize! :read, @item

    respond_to do |format|
      format.js
      format.json
    end
  end
end