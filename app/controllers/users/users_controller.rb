class Users::UsersController < ApplicationController
  load_and_authorize_resource
  before_action :get_user_data, except: %i[index profile]

  def index
    show_info({ "users" => gen_users })
  end

  def show
    show_info({ user: gen_user })
  end

  def update
    if @user.update(user_params)
      render json: { message: 'user updated succesfully', user: gen_user }
    else
      handle_error @user.errors.messages
    end
  end

  def destroy
    if @user.destroy
      success_response("User deleted successfully with id: #{@user.id}, email: #{@user.email}.")
    else
      faliure_response("Error Occured! User with id: #{@user.id} is not deleted")
    end
  end

  def profile
    if current_user
      @user = current_user
      show_info gen_user
    else
      faliure_response("Login first to continue")
    end
  end

  private

  def get_user_data
    @user = User.includes(:role).find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :library_name, :address, :email, :password, :role_id)
  end

end
