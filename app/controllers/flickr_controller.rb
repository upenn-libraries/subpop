class FlickrController < ApplicationController
  before_action :get_item

  def show
    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  def create
    if @item.publishable?
      create_jobs
      respond_to do |format|
        format.html { redirect_to @item, notice: "Publishing #{@item} to Flickr" }
        format.json { render :show, status: :created, location: @item }
      end
    else
      format.html { redirect_to @item, notice: "#{@item} is up-to-date or already being published to Flickr" }
      format.json { render json: [ "#{@item} is up-to-date or already being published to Flickr" ], status: :unprocessable_entity }
    end
  end

  def update
    if @item.publishable?
      create_jobs
      respond_to do |format|
        format.html { redirect_to @item, notice: "Publishing #{@item} to Flickr" }
        format.json { render :show, status: :created, location: @item }
      end
    else
      format.html { redirect_to @item, notice: "#{@item} is up-to-date or already being published to Flickr" }
      format.json { render json: [ "#{@item} is up-to-date or already being published to Flickr" ], status: :unprocessable_entity }
    end
  end

  def destroy
    if @item.unpublishable?
      @item.mark_in_process
      RemoveFromFlickrJob.perform_later @item
      respond_to do |format|
        format.html { redirect_to @item, notice: 'Removing photo from Flickr.' }
        format.json { head :no_content }
      end
    else
      format.html { redirect_to @item, notice: 'Cannot remove photo from Flickr.' }
      format.json { render json: [ 'Item cannot be removed from Flickr.' ], status: :unprocessable_entity }
   end
  end

  private
  def create_jobs
    return enqueue @item unless @item.is_a?(Book)

    # item is a book; enqueue each publishable
    @item.publishables.each { |item| enqueue item }
  end

  def enqueue item
    return unless item.publishable?

    item.mark_in_process
    return UpdateFlickrJob.perform_later item if item.on_flickr?
    AddToFlickrJob.perform_later item
  end

  def get_item
    item_type = params[:item_type]
    klass     = item_type.camelize.constantize
    @item     = klass.find params[:id]
  end
end
