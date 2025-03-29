class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params_permit[:email])

    if user
      if user.authenticate(params_permit[:password]) && user.role == params_permit[:role]
        session[:user_id] = user.id
        session[:role] = user.role
        flash[:notice] = "Logged in successfully as #{user.role.capitalize}."
        redirect_to user.role == 'hr' ? admin_leave_requests_path : leave_requests_path
      else
        flash[:alert] = "Invalid email, password, or role. Please try again."
        render :new
      end
    else
      unless %w[hr employee].include?(params_permit[:role])
        flash[:alert] = "Invalid role selected. Please try again."
        render :new
        return
      end

      user = User.create(user_params)
      if user.persisted?
        session[:user_id] = user.id
        session[:role] = user.role
        flash[:notice] = "Welcome! You have been registered as #{user.role.capitalize}."
        redirect_to user.role == "hr" ? admin_leave_requests_path : leave_requests_path
      else
        flash[:alert] = "Failed to register. Please try again."
        render :new
      end
    end
  end

  def destroy
    reset_session
    flash[:notice] = "You have successfully logged out."
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :role)
  end

  def params_permit
    params.permit(:email, :password, :role)
  end
end
