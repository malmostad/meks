RateCategory.where(name: "arrival_0_17").first.update(
  qualifier: "arrival_0_17",
  min_age: 0,
  max_age: 17
)

RateCategory.where(name: "assigned_0_17").first.update(
  qualifier: "assigned_0_17",
  min_age: 0,
  max_age: 17
)

RateCategory.where(name: "temporary_permit_0_17").first.update(
  qualifier: "temporary_permit",
  min_age: 0,
  max_age: 17
)

RateCategory.where(name: "temporary_permit_18_20").first.update(
  qualifier: "temporary_permit",
  min_age: 18,
  max_age: 20
)

RateCategory.where(name: "residence_permit_0_17").first.update(
  qualifier: "residence_permit",
  min_age: 0,
  max_age: 17
)

RateCategory.where(name: "residence_permit_18_20").first.update(
  qualifier: "residence_permit",
  min_age: 18,
  max_age: 20
)
