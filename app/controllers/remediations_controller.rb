class RemediationsController < ApplicationController
  before_action :set_remediation, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /remediations
  # GET /remediations.json
  def index
    @remediations = Remediation.all
  end

  # GET /remediations/1
  # GET /remediations/1.json
  def show
  end

  # GET /remediations/new
  def new
    @remediation = Remediation.new
  end

  # POST /remediations
  # POST /remediations.json
  def create
    @remediation = Remediation.new remediation_params

    respond_to do |format|
      if @remediation.save_by current_user
        format.html { redirect_to @remediation, notice: 'Remediation was successfully created.' }
        format.json { render :show, status: :created, location: @remediation }
      else
        format.html { render :new }
        format.json { render json: @remediation.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_remediation
      @remediation = Remediation.find params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def remediation_params
      params.require(:remediation).permit(:spreadsheet)
    end
end
