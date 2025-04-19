FactoryBot.define do
  factory :subscription do
    user
    plan_frequency
    start_date { Time.current }
    status { :active } # Assuming you're using an enum for status
  end
end
