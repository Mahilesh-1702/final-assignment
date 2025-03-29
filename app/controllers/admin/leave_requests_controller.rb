module Admin
  class LeaveRequestsController < ApplicationController
    before_action :authenticate_hr

    # HR can view leave requests
    def index
      @leave_requests = LeaveRequest.includes(:employee).where(hr_id: current_user.id)
    end

    # HR approves a leave request
    def approve
      leave_request = LeaveRequest.find(params[:id])
      leave_days = (leave_request.end_date - leave_request.start_date).to_i + 1

      if leave_request.employee.leave_balance >= leave_days
        leave_request.update(status: "Approved")
        leave_request.employee.decrement!(:leave_balance, leave_days)
        LeaveMailer.notify_decision(leave_request).deliver_now
        flash[:notice] = "Leave request approved successfully!"
      else
        leave_request.update(status: "Declined")
        LeaveMailer.notify_decision(leave_request).deliver_now
        flash[:alert] = "Insufficient leave balance for the employee."
      end

      redirect_to admin_leave_requests_path
    end

    # HR declines a leave request
    def decline
      leave_request = LeaveRequest.find(params[:id])
      leave_request.update(status: "Declined")
      LeaveMailer.notify_decision(leave_request).deliver_now
      flash[:notice] = "Leave request declined successfully."
      redirect_to admin_leave_requests_path
    end

    # HR exports leave requests as CSV
    def export
      @leave_requests = LeaveRequest.includes(:employee).where(hr_id: current_user.id)
      respond_to do |format|
        format.csv do
          headers['Content-Disposition'] = "attachment; filename=\"leave_requests-#{Date.today}.csv\""
          headers['Content-Type'] ||= 'text/csv'
          render template: "admin/leave_requests/export"
        end
      end
    end

    private

    # Authentication for HR
    def authenticate_hr
      unless current_user.role == "hr"
        flash[:alert] = "Unauthorized access."
        redirect_to root_path
      end
    end
  end
end
