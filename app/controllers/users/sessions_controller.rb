class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # This controller will handle user sessions

  private

  def respond_with(resource, _opts = {})
    if current_user
      # User sign in mail
      # UserMailer.welcome_email(current_user).deliver_later
      show_info({message:"#{current_user.name}! You're logged in Successfully"}) # ,jwt: response.headers.to_h
    else
      faliure_response("Login first to continue")
    end
  end

  def respond_to_on_destroy
    log_out_success && return if current_user
    log_out_failure
  end

  def log_out_success
    success_response("#{current_user.name}! Logged out Successfully")
  end

  def log_out_failure
    faliure_response("#{current_user.name}! Logout Failed!")
  end
end
