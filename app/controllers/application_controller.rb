class ApplicationController < ActionController::Base
  helper_method :current_user, :current_role

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_role
    session[:role]
  end

  def authenticate_user
    unless current_user
      flash[:alert] = "You must log in to access this page."
      redirect_to root_path
    end
  end

  def require_hr
    redirect_to root_path, alert: "Access denied" unless current_role == "hr"
  end

  def require_employee
    redirect_to root_path, alert: "Access denied" unless current_role == "employee"
  end
end
