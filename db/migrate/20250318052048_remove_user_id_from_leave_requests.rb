class RemoveUserIdFromLeaveRequests < ActiveRecord::Migration[8.0]
  def change
    remove_column :leave_requests, :user_id, :integer
  end
end
