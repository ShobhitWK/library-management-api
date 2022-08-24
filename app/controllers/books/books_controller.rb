class Books::BooksController < ApplicationController

  load_and_authorize_resource # authorization
  before_action :set_book, only: [:show, :update, :destroy]

  # GET /books
  def index
    @books = Book.all
    show_info({"books"=>gen_book_data(many=true)})
  end

  # GET /books/1
  def show
    show_info gen_book_data
  end

  # POST /books
  def create
    @book = Book.new(book_params)

    if @book.save
      render json: { message: "Book was created sucessfully!" , book: gen_book_data}, status: :created
    else
      handle_error @book.errors
    end
  end

  # PATCH/PUT /books/1
  def update
    if @book.update(book_params)
      render json: { "message" => "book updated successfully", "book" => gen_book_data}
    else
      handle_error @book.errors
    end
  end

  # DELETE /books/1
  def destroy
    if @book.destroy
      success_response("Book deleted successfully with id: #{@book.id}, name: #{@book.name}, book_creator: #{@book.user.name}")
    else
      faliure_response("Book is not deleted")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:name, :author, :edition, :quantity, :description, :user_id)
    end
end
