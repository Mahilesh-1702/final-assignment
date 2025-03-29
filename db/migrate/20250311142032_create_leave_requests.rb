class CreateLeaveRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :leave_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :hr, null: false, foreign_key: { to_table: :users }
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.text :reason, null: false
      t.string :status

      t.timestamps
    end
  end
end

