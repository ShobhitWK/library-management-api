class ApplicationController < ActionController::API
  # before_action :authenticate_user! # for internal server errors, this will check whether user is logged in or not
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Errors Handling

  rescue_from CanCan::AccessDenied do |exception|
    render json: { 'message' => 'User is not authorised for this action!' }, status: 401
    p exception
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    not_found_reponse('record not found!')
    p exception
  end

  rescue_from ActionController::ParameterMissing do |e|
    faliure_response("Wrong Parameters provided.")
  end

  def handlenotfound
    render json: { 'message' => "404 Not Found!"}, status: 404
  end

  # For Optimising Code...

  def handle_error(message)
    render json: { 'error' => message }, status: :unprocessable_entity
  end

  def success_response(message)
    render json: { 'message' => message }, status: 200
  end

  def faliure_response(message)
    render json: { 'message' => message }, status: 422
  end

  def not_found_reponse(message)
    render json: { 'message' => message }, status: 404
  end

  def show_info(response)
    render json: response, status: 200
  end

  # DEVISE PARAMS PERMITS

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:library_name,:address,:email,:password,:role_id])
  end

  # ROLES CHECK

  def user_admin
    current_user.role.name == "admin"
  end

  def user_student
    current_user.role.name == "student"
  end

  # checks

  def check_user_params
    params[:user].present?
  end

  private

  # This methods will generate custom output of json response

  def gen_users
    users = []
    @users.each do |user|
      if user.library_name == nil
        users << {
          id: user.id,
          email: user.email,
          user_name: user.name,
          user_role: user.role.name,
          role_id: user.role_id,
          address: user.address,
          user_url: users_user_url(user),
          created_at: user.created_at,
          updated_at: user.updated_at
        }
      else
        users << {
          id: user.id,
          email: user.email,
          user_name: user.name,
          user_role: user.role.name,
          role_id: user.role_id,
          address: user.address,
          library_name: user.library_name,
          books_amount: user.books.length,
          user_url: users_user_url(user),
          created_at: user.created_at,
          updated_at: user.updated_at
        }
      end
    end
    return users
  end

  def gen_user
    user = @user
    user_data=[]
    if user.library_name == nil
      user_data << {
        id: user.id,
        email: user.email,
        user_name: user.name,
        user_role: user.role.name,
        role_id: user.role_id,
        address: user.address,
        user_url: users_user_url(user),
        issued_books: gen_issued_book(many=true,custom=user),
        created_at: user.created_at,
        updated_at: user.updated_at
      }
    else
      user_data << {
        id: user.id,
        email: user.email,
        user_name: user.name,
        user_role: user.role.name,
        role_id: user.role_id,
        address: user.address,
        library_name: user.library_name,
        books_amount: user.books.length,
        books: gen_user_books(user),
        user_url: users_user_url(user),
        created_at: user.created_at,
        updated_at: user.updated_at
      }
    end
  end

  def gen_user_books(user)
    books = user.books.all
    data=[]
    books.each do |book|
      data << {
        book_id: book.id,
        book_name: book.name,
        book_author: book.author,
        book_description: book.description,
        book_edition: book.edition,
        book_quantity: book.quantity,
        book_created_at: book.created_at,
        book_updated_at: book.updated_at
      }
    end
    return data
  end

  def gen_book_data(many=false)
    data=[]
    if many == true
      @books.each do |book|
        data << {
          book_id: book.id,
          book_name: book.name,
          book_author: book.author,
          book_description: book.description,
          book_edition: book.edition,
          book_quantity: book.quantity,
          book_creator_id: book.user.id,
          book_created_by: book.user.name,
          book_creator_email: book.user.email,
          book_library_name: book.user.library_name,
          book_created_at: book.created_at,
          book_updated_at: book.updated_at
        }
      end
    else
      book = @book
      data << {
        book_id: book.id,
        book_name: book.name,
        book_author: book.author,
        book_description: book.description,
        book_edition: book.edition,
        book_quantity: book.quantity,
        book_creator_id: book.user.id,
        book_created_by: book.user.name,
        book_creator_email: book.user.email,
        book_library_name: book.user.library_name,
        book_created_at: book.created_at,
        book_updated_at: book.updated_at
      }
    end
    return data
  end

  def gen_issued_book(many=false,custom=nil)
    if custom
      @issuedbooks = custom.issuedbooks
    end
    data=[]
    if many == true
      @issuedbooks.each do |issuedbook|
        data << {
          id: issuedbook.id,
          issued_to_user_id: issuedbook.user.id,
          issued_to_user_name: issuedbook.user.name,
          issued_to_user_address: issuedbook.user.address,
          is_returned: issuedbook.is_returned,
          returned_on: issuedbook.return_dt,
          issue_created_at: issuedbook.created_at,
          issue_updated_at: issuedbook.updated_at,
          issued_on: issuedbook.issued_on,
          fine: issuedbook.fine,
          submission_by: issuedbook.submittion,
          bookinfo: {
            book_id: issuedbook.book.id,
            book_name: issuedbook.book.name,
            book_author: issuedbook.book.author,
            book_description: issuedbook.book.description,
            book_edition: issuedbook.book.edition,
            book_quantity: issuedbook.book.quantity,
            book_creator_id: issuedbook.book.user.id,
            book_created_by: issuedbook.book.user.name,
            book_creator_email: issuedbook.book.user.email,
            book_library_name: issuedbook.book.user.library_name,
            book_created_at: issuedbook.book.created_at,
            book_updated_at: issuedbook.book.updated_at
          }
        }
      end
    else
      issuedbook = @issuedbook
      data << {
        id: issuedbook.id,
        issued_to_user_id: issuedbook.user.id,
        issued_to_user_name: issuedbook.user.name,
        issued_to_user_address: issuedbook.user.address,
        is_returned: issuedbook.is_returned,
        returned_on: issuedbook.return_dt,
        issue_created_at: issuedbook.created_at,
        issue_updated_at: issuedbook.updated_at,
        issued_on: issuedbook.issued_on,
        fine: issuedbook.fine,
        submission_by: issuedbook.submittion,
        bookinfo: {
          book_id: issuedbook.book.id,
          book_name: issuedbook.book.name,
          book_author: issuedbook.book.author,
          book_description: issuedbook.book.description,
          book_edition: issuedbook.book.edition,
          book_quantity: issuedbook.book.quantity,
          book_creator_id: issuedbook.book.user.id,
          book_created_by: issuedbook.book.user.name,
          book_creator_email: issuedbook.book.user.email,
          book_library_name: issuedbook.book.user.library_name,
          book_created_at: issuedbook.book.created_at,
          book_updated_at: issuedbook.book.updated_at
        }
      }
    end
    return data
  end

end
