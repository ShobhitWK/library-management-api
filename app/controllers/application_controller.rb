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
    render html: "not found"
    render json: { 'message' => "404 Not Found!"}
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
      users << {
        id: user.id,
        user_name: user.name,
        user_role: user.role.name,
        email: user.email,
        created_at: user.created_at,
        updated_at: user.updated_at
      }
    end
    return users
  end

end
