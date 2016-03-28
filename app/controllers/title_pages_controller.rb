class TitlePagesController < ApplicationController
  before_action :set_title_page, only: [ :show ]

  def show
    respond_to do |format|
      format.html { redirect_to @title_page.book }
    end
  end

  private

  def set_title_page
    @title_page = TitlePage.find params[:id]
  end
end
