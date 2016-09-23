class PageContextController < ApplicationController
  include LinkToContextImage

  before_action :set_evidence

  def show
    # TODO
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

  private

  def evidence_params
    params.require(:evidence).permit(
      :context_image_id,
      :context_photo_id
      )
  end

  def set_evidence
    @evidence = Evidence.find params[:id]
  end
end