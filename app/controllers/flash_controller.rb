class FlashController < ApplicationController
  def show
    @type = params[:type]
    @message = params[:message]
    respond_to do |format|
      format.js
    end
  end
end
