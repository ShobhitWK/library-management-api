class Books::IssuedbooksController < ApplicationController
  load_and_authorize_resource
  before_action :set_issuedbook, only: [:show, :update, :destroy]

  # GET /issuedbooks
  def index
    if current_user.role.name == "admin"
      @issuedbooks = Issuedbook.all
    else
      @issuedbooks = current_user.issuedbooks
    end
    if @issuedbooks.empty?
      show_info({message:"there are no books to show"})
    else
      show_info({issuedbooks: gen_issued_book(many=true)})
    end
  end

  # GET /issuedbooks/1
  def show
    if current_user.role.name == "admin"
      show_info gen_issued_book
    elsif current_user.id == @issuedbook.user.id
      show_info gen_issued_book
    else
      faliure_response("The book you're trying to view is not issued by you")
    end
  end

  # POST /issuedbooks
  def create

    @issuedbook = Issuedbook.new(issuedbook_creation_params)
    books = current_user.issuedbooks
    array = []
    books.each do |book|
      array << book.book_id
    end
    if array.include?(@issuedbook.book.id)
      faliure_response("you already have this book issued")
    else
      if @issuedbook.book.quantity > 0

        @issuedbook.book.quantity -= 1
        @issuedbook.user = current_user
        @issuedbook.is_returned = false
        @issuedbook.issued_on = DateTime.now
        @issuedbook.fine = 20.00

        if @issuedbook.save
          @issuedbook.book.save
          render json: {book_issued: gen_issued_book}, status: :created, location: @issuedbook
        else
          handle_error @issuedbook.errors
        end
      else
        faliure_response("Book is not available for issuing.")
      end
    end
  end

  # PATCH/PUT /issuedbooks/1
  def update
    if @issuedbook.is_returned == true
      faliure_response("Cant't update, the book is already returned")
    else
      if @issuedbook.update(issuedbook_params)
        show_info gen_issued_book
      else
        handle_error @issuedbook.errors
      end
    end
  end

  # DELETE /issuedbooks/1
  def destroy
    if @issuedbook.destroy
      if @issuedbook.is_returned == false
        @issuedbook.book.quantity += 1
        success_response("IssuedBook-request deleted successfully with id: #{@issuedbook.id}, issuer_name: #{@issuedbook.user.name}, book_creator: #{@issuedbook.book.user.name}")
      else
        @issuedbook.book.save
        success_response("IssuedBook-request deleted successfully with id: #{@issuedbook.id}, issuer_name: #{@issuedbook.user.name}, book_creator: #{@issuedbook.book.user.name}")
      end
    else
      faliure_response("IssuedBook-request is not deleted")
    end
  end

  def return
    @issuedbook = Issuedbook.find(params[:id])
    if @issuedbook.is_returned == true
      faliure_response("Book is already returned")
    else
      if @issuedbook.user == current_user
        @issuedbook.return_dt = DateTime.now
        @issuedbook.book.quantity += 1
        @issuedbook.is_returned = true
        @issuedbook.save
        @issuedbook.book.save
        success_response(gen_issued_book)
      else
        faliure_response("This book is not issued by you.")
      end
    end
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

    def issuedbook_creation_params
      params.require(:issuedbook).permit(:book_id, :submittion)
    end
end
