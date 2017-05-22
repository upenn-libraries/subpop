class NamesController < ApplicationController
  before_action :set_name, only: [:show, :edit, :update, :destroy]
  authorize_resource

  autocomplete :name, :name, full: true

  # GET /names
  # GET /names.json
  def index
    respond_to do |format|
      format.html {
        @search ||= params[:search]
        if @search.present?
          @names = Name.name_like("%#{params[:search]}%").order('name').page(params[:page])
        else
          @names = Name.order(:name).page params[:page]
        end
      }
      format.json { @names = Name.name_like("%#{params[:term]}%").order('name').limit(20) }
    end
  end

  # GET /names/1
  # GET /names/1.json
  def show
  end

  # GET /names/new
  def new
    @name = Name.new
    respond_to do |format|
      if request.xhr?
        format.html {
          @modal = true
          render layout: false
        }
      else
        format.html
      end
    end
  end

  # GET /names/1/edit
  def edit
  end

  # POST /names
  # POST /names.json
  def create
    @name = Name.new(name_params)

    respond_to do |format|
      if @name.save_by current_user
        format.html { redirect_to @name, notice: 'Name was successfully created.' }
        format.json { render :show, status: :created, location: @name }
        format.js   { render :show, status: :created, location: @name }
      else
        format.html { render :new }
        format.json { render status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /names/1
  # PATCH/PUT /names/1.json
  def update
    respond_to do |format|
      if @name.update_by current_user, name_params
        format.html { redirect_to @name, notice: 'Name was successfully updated.' }
        format.json { render :show, status: :ok, location: @name }
      else
        format.html { render :edit }
        format.json { render status: :unprocessable_entity }
      end
    end
  end

  # DELETE /names/1
  # DELETE /names/1.json
  def destroy
    @name.destroy
    respond_to do |format|
      format.html { redirect_to names_url, notice: 'Name was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_name
      @name = Name.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def name_params
      params.require(:name).permit(:name, :year_start, :year_end, :viaf_id, :comment, :gender)
    end
end
