class Flickr::BaseController < ApplicationController
  include FlickrHelper

  before_action :get_item, only: [ :show, :status, :create, :update, :destroy ]

  # Subclasses must implement this and return a item class for the
  # controller
  def item_class
    controller_name.camelize.singularize.constantize
  end

  def item_class_lstr
    item_class.to_s.underscore
  end

  def show
    authorize! :read, @item

    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  def status
    authorize! :read, @item

    respond_to do |format|
      format.js
      format.json
    end
  end

  def create
    authorize! :update, @item

    respond_to do |format|
      if @item.publishable?
        create_publish_jobs
        format.json { render json: @item }
        format.js
        format.html { redirect_to @item, notice: "Publishing #{@item} to Flickr" }
      else
        format.html { redirect_to @item, notice: "#{@item} is up-to-date or already being published to Flickr" }
        format.json { render json: [ "#{@item} is up-to-date or already being published to Flickr" ], status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :update, @item

    respond_to do |format|
      if @item.publishable?
        create_publish_jobs
        format.js
        format.json { render json: @item }
        format.html { redirect_to @item, notice: "Publishing #{@item} to Flickr" }
      else
        format.html { redirect_to @item, notice: "#{@item} is up-to-date or already being published to Flickr" }
        format.json { render json: [ "#{@item} is up-to-date or already being published to Flickr" ], status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :udpate, @item

    respond_to do |format|
      if @item.unpublishable?
        create_unpublish_jobs
        format.js
        format.json { render json: @item }
        format.html { redirect_to @item, notice: 'Removing photo from Flickr.' }
      else
        format.js   { redirect_to @item, notice: 'Cannot remove photo from Flickr.' }
        format.html { redirect_to @item, notice: 'Cannot remove photo from Flickr.' }
        format.json { render json: [ 'Item cannot be removed from Flickr.' ], status: :unprocessable_entity }
      end
    end
  end

  private

  def create_publish_jobs
    return enqueue_publish @item unless @item.respond_to? :publishables

    # item is a book; enqueue each publishable
    @item.publishables.each { |item| enqueue_publish item }
  end

  def enqueue_publish item
    return unless item.publishable?

    item.mark_in_process
    return UpdateFlickrJob.perform_later item, current_user.id if item.on_flickr?
    AddToFlickrJob.perform_later item, current_user.id
  end

  def create_unpublish_jobs
    return enqueue_unpublish @item unless @item.respond_to? :publishables

    # item is a book; add all unpublishable items
    @item.publishables.each { |item| enqueue_unpublish item }
  end

  def enqueue_unpublish item
    return unless item.unpublishable?

    item.mark_in_process
    RemoveFromFlickrJob.perform_later item
  end

  def get_item
    @item = item_class.find params[:id]
  end
end
