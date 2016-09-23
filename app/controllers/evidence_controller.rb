class EvidenceController < ApplicationController

  before_action :set_book, only: [ :new, :create, :destroy ]
  before_action :set_evidence, only: [:show, :edit, :update, :destroy, :choose_context_image, :update_context_image ]

  authorize_resource

  autocomplete :name, :name, full: true

  # GET /evidence
  # GET /evidence.json
  def index
    @evidence = Evidence.all
  end

  # GET /evidence/1
  # GET /evidence/1.json
  def show
  end

  # GET /evidence/new
  def new
    @evidence = @book.evidence.build evidence_params
  end

  # GET /evidence/1/edit
  def edit
  end

  # POST /evidence
  # POST /evidence.json
  def create
    @evidence = @book.evidence.build evidence_params

    respond_to do |format|
      if @evidence.save_by current_user
        @evidence.dequeue_photo
        format.html {
          redirect_to @evidence, notice: 'Evidence was successfully created.'
        }
        format.json { render :show, status: :created, location: @evidence }
      else
        format.html { render :new }
        format.json { render json: @evidence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /evidence/1
  # PATCH/PUT /evidence/1.json
  def update
    respond_to do |format|
      if @evidence.update_by current_user, evidence_params
        format.html { redirect_to [@evidence], notice: 'Evidence was successfully updated.' }
        format.json { render :show, status: :ok, location: @evidence }
      else
        format.html { render :edit }
        format.json { render json: @evidence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /evidence/1
  # DELETE /evidence/1.json
  def destroy
    @evidence.requeue_photo
    @evidence.save_by current_user
    @evidence.mark_deleted
    DeletePublishableJob.perform_later @evidence, current_user
    respond_to do |format|
      format.js
      format.html { redirect_to @book, notice: 'Evidence was deleted.' }
    end
  end

  private
    def get_photo
      Photo.find params[:photo_id] if params[:photo_id].present?
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_evidence
      @evidence = Evidence.includes(:book).find params[:id]
    end

    def set_book
      @book = Book.find(params[:book_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evidence_params
      params.require(:evidence).permit(
        :book_id,
        :format,
        :format_other,
        :content_type,
        :location_in_book,
        :location_in_book_page,
        :transcription,
        :year_when,
        :year_start,
        :year_end,
        :date_narrative,
        :where,
        :comments,
        :citations,
        :photo,
        :photo_id,
        :context_photo_id,
        content_type_ids: [],
        provenance_agents_attributes: [ :id, :name_id, :role, :_destroy ]
        )
    end
end
