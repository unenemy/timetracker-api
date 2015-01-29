class Employee < User
  validates :password, presence: true, confirmation: :password_confirmation, on: :create
  has_many :timetracks
end
