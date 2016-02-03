FactoryGirl.define do
  factory :dossier_number do
    name rand(100_000..999_999)
  end
end
