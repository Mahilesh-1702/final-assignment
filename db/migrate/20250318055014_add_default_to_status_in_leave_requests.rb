class AddDefaultToStatusInLeaveRequests < ActiveRecord::Migration[8.0]
  def change
    change_column_default :leave_requests, :status, from: nil, to: "Pending"
  end
end
