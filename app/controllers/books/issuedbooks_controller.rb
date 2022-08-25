class Books::IssuedbooksController < ApplicationController
  load_and_authorize_resource
  before_action :set_issuedbook, only: [:show, :update, :destroy]

  # GET /issuedbooks
  def index
    @issuedbooks = Issuedbook.all
    # render json: @issuedbooks
    show_info({issuedbooks: gen_issued_book(many=true)})
  end

  # GET /issuedbooks/1
  def show
    render json: @issuedbook
  end

  # POST /issuedbooks
  def create
    @issuedbook = Issuedbook.new(issuedbook_params)

    if @issuedbook.save
      render json: @issuedbook, status: :created, location: @issuedbook
    else
      render json: @issuedbook.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /issuedbooks/1
  def update
    if @issuedbook.update(issuedbook_params)
      render json: @issuedbook
    else
      render json: @issuedbook.errors, status: :unprocessable_entity
    end
  end

  # DELETE /issuedbooks/1
  def destroy
    @issuedbook.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issuedbook
      @issuedbook = Issuedbook.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def issuedbook_params
      params.require(:issuedbook).permit(:user_id, :book_id, :is_returned, :issued_on, :fine, :return_dt, :submittion)
    end
end
