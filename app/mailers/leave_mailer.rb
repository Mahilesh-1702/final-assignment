class LeaveMailer < ApplicationMailer
  default from: 'no-reply@company.com'

  # Existing method for notifying HR of a new leave request
  def leave_request_email(leave_request)
    @leave_request = leave_request
    mail(
      to: @leave_request.hr.email,
      cc: @leave_request.employee.email, # Updated for consistency (using `employee` instead of `user`)
      subject: "New Leave Request from #{@leave_request.employee.name}"
    )
  end

  # New method for notifying employee of leave request decision
  def notify_decision(leave_request)
    @leave_request = leave_request
    @employee = @leave_request.employee
    @status = @leave_request.status

    mail(
      to: @employee.email,
      subject: "Your Leave Request has been #{@status}"
    )
  end
end
