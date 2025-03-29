class AddDefaultsAndIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :leave_requests, :employee_id
    change_column_default :users, :leave_balance, from: nil, to: 30
  end
end
