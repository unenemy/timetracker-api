FactoryGirl.define do
  factory :timetrack do
    description { Faker::Lorem.sentence }
    amount_in_minutes 1
    log_date "2015-01-29"
  end
end
