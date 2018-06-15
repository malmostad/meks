FactoryBot.define do
  factory :placement do
    refugee { create(:refugee) }
    home { create(:home) }
    legal_code { create(:legal_code) }
    moved_in_at { Date.today }
  end
end
