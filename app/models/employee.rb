class Employee < User
  validates :password, presence: true, confirmation: :password_confirmation, on: :create
end
