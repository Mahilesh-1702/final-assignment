class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :role
      t.string :password_digest
      t.integer :leave_balance, default: 30 # Set default leave balance to 30

      t.timestamps
    end
  end
end
