FactoryBot.define do
  factory :plan_frequency do
    association :plan # This will automatically associate the plan with this plan_frequency
    frequency_type { 1 }  # You can adjust this to a valid frequency type
    price { 100.00 } # You can adjust the price as needed

    # Add any other attributes you need here
  end
end
