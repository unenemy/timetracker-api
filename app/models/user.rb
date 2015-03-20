class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  has_secure_password
  has_many :tokens

  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end

  def authenticate(password)
    if super(password)
      [tokens.create.token, self]
    else
      [false, self]
    end
  end

  def employee?
    is_a?(Employee)
  end

  def manager?
    is_a?(Manager)
  end
end
