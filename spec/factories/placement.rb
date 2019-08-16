FactoryBot.define do
  factory :placement do
    person { create(:person) }
    home { create(:home) }
    legal_code { create(:legal_code) }
    moved_in_at { Date.today }
  end

  factory :placement_with_rate_exempt, class: Placement do
    person { create(:person) }
    home { create(:home) }
    legal_code { create(:legal_code_with_exempt) }
  end
end
