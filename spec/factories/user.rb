FactoryGirl.define do
  factory :employee do
    email { Faker::Internet.email }
    password 'password'
  end
  factory :manager do
    email { Faker::Internet.email }
    password 'password'
  end
end
