class Users::UsersController < ApplicationController
  # load_and_authorize_resource
  before_action :get_user_data, except: %i[index]

  def index
    render json: { "users" => User.all }
  end

  def show
    return render json: { user: @user } 
    # handle_error 'Can\'t view this user!'
  end

  def update
    if @user.update(user_params)
      render json: { message: 'user updated succesfully', user: user_info }
    else
      handle_error @user.errors.messages
    end
  end

  def destroy
    if @user.destroy
      success_response("User deleted succesfully.")
    else
      faliure_response("Error Occured! User is not deleted")
    end
  end

  def update_role
    if @user.update(role_params)
      success_response('Role updated successfully')
    else
      faliure_response('Role is not updated')
    end
  end

  private

  def role_params
    params.require(:user).permit(:role_id)
  end

  def get_user_data
    @user = User.includes(:role).find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :role_id)
  end

end
