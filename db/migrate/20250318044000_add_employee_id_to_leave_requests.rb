class AddEmployeeIdToLeaveRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :leave_requests, :employee_id, :integer
  end
end
