class User < ApplicationRecord
  has_secure_password

  has_many :leave_requests, foreign_key: :user_id, dependent: :destroy
  has_many :handled_requests, class_name: 'LeaveRequest', foreign_key: :hr_id, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 } # Added password validation
  validates :role, presence: true, inclusion: { in: %w[employee hr] } # Ensures valid roles

  before_create :initialize_leave_balance

  private

  def initialize_leave_balance
    self.leave_balance ||= 30 if role == 'employee'
  end
end
