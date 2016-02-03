FactoryGirl.define do
  factory :refugee do
    sequence(:name) { |n| "name-#{n}" }
    draft false
    date_of_birth { Date.today  - 4.years - rand(16).years }
    ssn_extension rand(1000..9999)
    dossier_number rand(100_000..999_999)
    registered { Date.today - rand(24).months }
    deregistered { Date.today - rand(12).months }
    residence_permit_at { Date.today - rand(3).months }
    temporary_permit_starts_at { Date.today - rand(3).months }
    temporary_permit_ends_at { temporary_permit_ends_at + rand(3).months }
    municipality_placement_migrationsverket_at { Date.today - rand(3).months }
    municipality_placement_per_agreement_at { Date.today - rand(3).months }
    municipality_placement_comment "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    special_needs { rand(2).zero? ? true : false }
    other_relateds "First Last"
    comment "Comment ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

    association :deregistered_reason, :gender, :municipality, :relateds
  end
end
