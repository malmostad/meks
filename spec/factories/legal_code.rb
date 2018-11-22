FactoryBot.define do
  factory :legal_code do
    sequence(:name) { |n| "legal_code-#{n}" }
  end

  factory :legal_code_with_exempt, class: LegalCode do
    sequence(:name) { |n| "legal_code_with_exempt-#{n}" }
    exempt_from_rate { true }
  end
end
