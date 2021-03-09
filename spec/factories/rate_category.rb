FactoryBot.define do
  factory :rate_category do
    name { "arrival_0_17" }
    human_name { "Ankomstbarn 0–17 år" }
    qualifier { "arrival_0_17" }
    min_age { 0 }
    max_age { 1 }
  end

  factory :arrival_0_17, parent: :rate_category do
    name { "arrival_0_17" }
    human_name { "Ankomstbarn 0–17 år" }
    qualifier { "arrival_0_17" }
    min_age { 0 }
    max_age { 1 }
  end

  factory :assigned_0_17, parent: :rate_category do
    name { "assigned_0_17" }
    human_name { "Anvisade barn 0–17 år" }
    qualifier { "assigned_0_17" }
    min_age { 0 }
    max_age { 17 }
  end

  factory :temporary_permit_0_17, parent: :rate_category do
    name { "temporary_permit_0_17" }
    human_name { "TUT-barn 0–17 år" }
    qualifier { "temporary_permit" }
    min_age { 0 }
    max_age { 17 }
  end

  factory :temporary_permit_18_20, parent: :rate_category do
    name { "temporary_permit_18_20" }
    human_name { "TUT-barn 18–20 år" }
    qualifier { "temporary_permit" }
    min_age { 18 }
    max_age { 20 }
  end

  factory :residence_permit_0_17, parent: :rate_category do
    name { "residence_permit_0_17" }
    human_name { "PUT-barn 0–17 år" }
    qualifier { "residence_permit" }
    min_age { 0 }
    max_age { 17 }
  end

  factory :residence_permit_18_20, parent: :rate_category do
    name { "residence_permit_18_20" }
    human_name { "PUT-barn 18–20 år" }
    qualifier { "residence_permit" }
    min_age { 18 }
    max_age { 20 }
  end
end
