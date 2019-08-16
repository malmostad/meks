FactoryBot.define do
  factory :person do
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

  factory :person_assigned_0_17, parent: :person do
    date_of_birth { '2000-07-01' }
    municipality_placement_migrationsverket_at { '2018-01-01' }
    checked_out_to_our_city { '2018-07-01' }
    deregistered { '2018-07-02' }
    municipality { create(:municipality, our_municipality: true) }
  end

  factory :person_arrival_0_17, parent: :person do
    date_of_birth { '2010-01-01' }
    registered { '2018-01-01' }
    deregistered { nil }
    municipality_placement_migrationsverket_at { '2019-01-01' }
    temporary_permit_starts_at { '2019-01-01' }
    residence_permit_at { nil }
  end

  factory :person_residence_permit_0_17, parent: :person do
    date_of_birth { '2010-01-01' }
    residence_permit_at { '2018-04-01' }
    checked_out_to_our_city { '2018-01-01' }
    deregistered { nil }
  end

  factory :person_residence_permit_18_20, parent: :person do
    date_of_birth { '1999-07-01' }
    residence_permit_at {  '2018-04-01' }
    checked_out_to_our_city { '2018-01-01' }
    deregistered { nil }
  end

  factory :person_temporary_permit_0_17, parent: :person do
    date_of_birth { '2010-01-01' }
    checked_out_to_our_city { '2018-04-01' }
    temporary_permit_starts_at { '2018-01-01' }
    temporary_permit_ends_at { '2020-01-01' }
    residence_permit_at { nil }
    deregistered { nil }
  end

  factory :person_temporary_permit_18_20, parent: :person do
    date_of_birth { '1999-07-01' }
    checked_out_to_our_city { '2018-04-01' }
    temporary_permit_starts_at { '2018-01-01' }
    temporary_permit_ends_at { '2020-01-01' }
    residence_permit_at { nil }
    deregistered { nil }
  end
end
