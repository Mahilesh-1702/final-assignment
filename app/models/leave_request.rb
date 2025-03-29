class LeaveRequest < ApplicationRecord
  belongs_to :employee, class_name: 'User', foreign_key: :employee_id
  belongs_to :hr, class_name: 'User', foreign_key: :hr_id

  validates :start_date, :end_date, :reason, presence: true
  validate :valid_date_range, :sufficient_leave_balance, :no_overlapping_dates

  def self.to_csv
    attributes = %w[employee_name start_date end_date reason status]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |leave_request|
        csv << [
          leave_request.employee&.name || "Unknown",
          leave_request.start_date,
          leave_request.end_date,
          leave_request.reason,
          leave_request.status
        ]
      end
    end
  end

  private

  def valid_date_range
    if start_date > end_date
      errors.add(:base, "End date must be on or after the start date.")
    end
  end

  def sufficient_leave_balance
    return if employee.leave_balance >= leave_days
    errors.add(:base, "Not enough leave balance.")
  end

  def no_overlapping_dates
    overlapping_requests = LeaveRequest
                            .where(employee_id: employee_id)
                            .where("start_date <= ? AND end_date >= ?", end_date, start_date)
                            .where.not(id: id)
    if overlapping_requests.exists?
      errors.add(:base, "Overlapping leave requests are not allowed.")
    end
  end

  def leave_days
    (end_date - start_date).to_i + 1
  end
end
