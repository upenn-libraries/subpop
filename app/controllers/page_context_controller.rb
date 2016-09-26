##
# PageContextController is used to locate ContextImages for dynamic rediplay
# on evidence pages following an image crop.
#
# The `show` action locates the ContextImage for the provided Evidence `:id`.
# The `find` action locates the ContextImage for the provided Photo
# `:derivative_id`.
#
# The `:derivative_id` method for locating the ContextImage is required on the
# new Evidence page, as the evidence instance on that page is new and has no
# `id`.
class PageContextController < ApplicationController
  include LinkToContextImage

  before_action :set_evidence
  before_action :set_derivative, only: [:find]

  def show
    @context_image = @evidence.context_image
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  def update
    link_to_context_image @evidence, evidence_params[:context_photo_id]

    respond_to do |format|
      if @evidence.update_by current_user, context_image: @context_image
        format.html { redirect_to @evidence }
        format.js
      else
        format.html { render :choose_context_image }
      end
    end
  end

  def find
    @context_image = find_context_image @derivative
    respond_to do |format|
      # format.html
      format.js
    end
  end

  private

  def find_context_image derivative
    return unless derivative.present?
    return unless derivative.original_id.present?

    ContextImage.find_by photo_id: derivative.original_id
  end

  def evidence_params
    params.require(:evidence).permit(
      :context_image_id,
      :context_photo_id
      )
  end

  def set_evidence
    return if params[:id].blank?
    return if params[:id] == 'new'

    @evidence = Evidence.find params[:id]
  end

  def set_derivative
    return unless params[:derivative_id].present?
    @derivative = Photo.find params[:derivative_id]
  end
end