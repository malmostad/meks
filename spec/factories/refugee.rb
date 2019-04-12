FactoryBot.define do
  factory :refugee do
    sequence(:name) { |n| "name-#{n}" }
    draft { false }
    date_of_birth { '2005-01-01' }
    ssn_extension { rand(1000..9999) }
    dossier_number { rand(100_000..999_999) }
    registered { '2018-01-01' }
    deregistered { nil }
    residence_permit_at { nil }
    temporary_permit_starts_at { nil }
    temporary_permit_ends_at { nil }
    municipality_placement_migrationsverket_at { nil }
    municipality_placement_comment { nil }
    special_needs { false }
    other_relateds { 'First Last' }
    deregistered_reason { nil }

    gender { create(:gender) }
    municipality { create(:municipality) }
    languages { create_list(:language, 2) }
    countries { create_list(:country, 2) }
    citizenship_at { nil }
  end
end
