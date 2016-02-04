FactoryGirl.define do
  factory :placement do
    refugee { create(:refugee) }
    home { create(:home) }
    moved_in_at { Date.today }
  end
end
