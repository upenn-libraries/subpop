class FlickrController < ApplicationController
  before_action :get_item

  def show
    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  def create
    handle_publication
  end

  def update
    handle_publication
  end

  def destroy
    if @item.unpublishable?
      @item.unpublish
      respond_to do |format|
        format.html { redirect_to @item, notice: 'Removing photo from Flickr.' }
        format.json { head :no_content }
      end
    else
      format.html { redirect_to @item, notice: 'Cannot remove photo from Flickr.' }
      format.json { render json: [ 'Item cannot be remove from Flickr.' ], status: :unprocessable_entity }
   end
  end

  private
  def handle_publication
    get_item
    if @item.publishable?
      notice = "Publishing #{@item.class} to Flickr"
      @item.publish!
    else
      notice = "#{@item.class} up-to-date or already being published to Flickr"
    end
    redirect_to @item, notice: notice
  end

  def get_item
    item_type = params[:item_type]
    klass     = item_type.camelize.constantize
    @item     = klass.find params[:id]
  end
end
