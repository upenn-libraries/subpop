class RemediationsController < ApplicationController
  before_action :set_remediation, only: [:show, :edit, :update, :destroy]

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

  # GET /remediations/1/edit
  def edit
  end

  # POST /remediations
  # POST /remediations.json
  def create
    @remediation = Remediation.new(remediation_params)

    respond_to do |format|
      if @remediation.save
        format.html { redirect_to @remediation, notice: 'Remediation was successfully created.' }
        format.json { render :show, status: :created, location: @remediation }
      else
        format.html { render :new }
        format.json { render json: @remediation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /remediations/1
  # PATCH/PUT /remediations/1.json
  def update
    respond_to do |format|
      if @remediation.update(remediation_params)
        format.html { redirect_to @remediation, notice: 'Remediation was successfully updated.' }
        format.json { render :show, status: :ok, location: @remediation }
      else
        format.html { render :edit }
        format.json { render json: @remediation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /remediations/1
  # DELETE /remediations/1.json
  def destroy
    @remediation.destroy
    respond_to do |format|
      format.html { redirect_to remediations_url, notice: 'Remediation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_remediation
      @remediation = Remediation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def remediation_params
      params.require(:remediation).permit(:problems, :created_by_id, :updated_by_id)
    end
end
