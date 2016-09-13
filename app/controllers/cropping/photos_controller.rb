##
# Cropping controller for photos. Always expects a parent model (Book,
# Evidence, TitlePage, or ContextImage) and a Photo. The `#create` action
# expects a source_photo_id paramter, which is used by the
# ThumbnailsController to find the correct divs in which to display the new
# image.
#
# Note that this is a rather willful use of the rails pattern of nesting
# resources. Strictly speaking the nested model should have a `:belongs_to`
# assocation with its parent. This is true for Books and Photos, but
# contrarily Evidence, TitlePage, and ContextImage belong to Photos.
#
# This method serves the need to have single controller and set of views
# handle the editing an redisplay of all image types when editing occurs.
#
# There are two key div types, `.thumb-contatiner` and `.thumb-div`. They look
# like this:
#
# ```html
# <div class="thumb-container" data-parent="32" data-parent-type="title_pages" data-thumbnail="118" id="ui-id-2">
#   <div class="thumb" data-parent="32" data-parent-type="title_pages" data-thumbnail="118">
#     <a target="_blank" data-toggle="tooltip" rel="noopener noreferrer" href="/system/photos/images/000/000/118/original/data.jpg?1472843017" data-original-title="Click to open in new window.">
#       <img class="img-responsive center-block" src="/system/photos/images/000/000/118/thumb/data.jpg?1472843017" alt="Data">
#     </a>
#   </div>
# </div>
# ```
#
# The `.thumb` div is generated in the `/thumbnails/show` partial.  The
# `.thumb` div has an optional `data-source-photo` attribute to hold the ID of
# the photo from which the new photo was created. The code that dynamically
# loads the new image, must know the ID of the previous photo in order to find
# the correct parent div to replace its content. The `data-source-photo`
# attribute makes this possible when a photo is new.
class Cropping::PhotosController < ApplicationController
  include ApplicationHelper
  include PolymorphicParent

  before_action :set_or_create_parent
  before_action :set_parent_type,   only:   [:new, :create]
  before_action :set_photo,         except: [:new, :create]
  before_action :set_source_photo,  only:   [:new, :create]

  def create
    authorize! :update, @source_photo

    @photo = build_photo @parent, photo_params

    if @photo.save

      # we have to save non-Books with the new photo
      update_parent @parent, @photo
      respond_to do |format|
        format.html { redirect_to @parent }
        format.js {
          redirect_to parent_thumbnail_path(@parent,@photo, source_photo_id: @source_photo.id),  format: :js
        }
      end
    else
      format.html { render :new }
    end
  end

  def new
    # All authorization eventually depends on the book. We assume that the the
    # @source_photo has a connection to the book, either directly or one of the
    # three publishable types: Evidence, TitlePage, or ContextImage
    authorize! :update, @source_photo

    @photo = build_photo @parent, photo_params

    respond_to do |format|
      format.html {
        if request.xhr?
          render layout: false
        else
          render layout: 'cropper'
        end
      }
    end
  end

  def edit
    authorize! :update, @photo

    respond_to do |format|
      format.html do
        if request.xhr?
          render layout: false
        else
          render layout: 'cropper'
        end
      end
    end
  end

  def update
    authorize! :update, @photo
    @photo.assign_attributes photo_params

    # @photo.image = @photo.data_url
    if @photo.save
      respond_to do |format|
        format.html { redirect_to @parent }
        format.js {
          redirect_to parent_thumbnail_path(@parent,@photo),  format: :js
        }
      end
    else
      format.html { render :edit }
    end
  end

  private

  def update_parent parent, photo
    return unless parent.persisted?
    return if parent.is_a? Book
    @parent.update_attributes photo: photo
  end

  def set_photo
    @photo = Photo.find params[:id]
  end

  def set_source_photo
    @source_photo = Photo.find params[:source_photo_id]
  end

  def build_photo parent, params={}
    return parent.photos.build params if parent.is_a?(Book)
    Photo.new params
  end

  def photo_params
    return unless params[:photo]
    params.require(:photo).permit :data_url, :parent_type
  end
end
