FactoryBot.define do
  factory :plan do
    name { "Premium" }
    description { "Lorem ipsum dolor sit amet, consectetur adipiscing elit." }
    features { ["Plantas especiais", "Atendimento no whatsapp", "Pronta entrega"].to_json }

    # Add any additional attributes you need here
  end
end

