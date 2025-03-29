class LeaveRequestsController < ApplicationController
  before_action :set_hr_managers, only: [:new, :create] # Fetch HR managers for dropdown
  
  def index
    @leave_requests = LeaveRequest.where(employee_id: current_user.id) # Corrected to use employee_id
  end

  def export
    @leave_requests = LeaveRequest.where(employee_id: current_user.id)

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"leave_requests.csv\""
        headers['Content-Type'] ||= 'text/csv'

        render template: "leave_requests/export"
      end
    end
  end
  
  def new
    @leave_request = LeaveRequest.new
  end

  def create
    @leave_request = LeaveRequest.new(leave_request_params)
    @leave_request.employee_id = current_user.id # Associate leave request with current employee
    @leave_request.hr_id = params[:leave_request][:hr_id] # Associate request with selected HR
    @leave_request.status ||= "Pending" # Ensure the status is set to "Pending"
    if @leave_request.save
      # Notify HR and employee via email
      LeaveMailer.leave_request_email(@leave_request).deliver_now
      redirect_to leave_requests_path, notice: "Leave request submitted successfully."
    else
      flash[:alert] = "Failed to submit leave request. Please try again."
      render :new
    end
  end

  def approve
    @leave_request = LeaveRequest.find(params[:id])
    leave_days = (@leave_request.end_date - @leave_request.start_date).to_i + 1
    if @leave_request.employee.leave_balance >= leave_days
      @leave_request.update(status: "Approved") # Set status to 'Approved'
      @leave_request.employee.decrement!(:leave_balance, leave_days) # Deduct leave days
      LeaveMailer.notify_decision(@leave_request).deliver_now # Notify employee of approval
      redirect_to leave_requests_path, notice: "Leave request approved successfully."
    else
      @leave_request.update(status: "Declined")
      LeaveMailer.notify_decision(@leave_request).deliver_now # Notify employee of declination
      redirect_to leave_requests_path, alert: "Insufficient leave balance. Leave request declined."
    end
  end
    
  def decline
    @leave_request = LeaveRequest.find(params[:id])
    @leave_request.update(status: "Declined") # Set status to 'Declined'
    LeaveMailer.notify_decision(@leave_request).deliver_now # Notify employee of declination
    redirect_to leave_requests_path, notice: "Leave request declined successfully."
  end

  private

  def set_hr_managers
    # Fetch only users with the HR role to populate the dropdown
    @hrs = User.where(role: 'hr')
  end

  def leave_request_params
    # Permit required fields for leave request
    params.require(:leave_request).permit(:start_date, :end_date, :reason, :hr_id)
  end
end
