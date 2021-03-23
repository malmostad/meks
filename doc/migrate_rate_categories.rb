rate_categories = %w[arrival_0_17 assigned_0_17 temporary_permit_0_17 temporary_permit_18_20  residence_permit_0_17 residence_permit_18_20]

rate_categories.each do |rc|
  r = RateCategory.where(name: rc).first
  r.update_attributes(qualifier: r.qualifier[:meth], min_age: r.qualifier[:min_age], max_age: r.qualifier[:max_age])
end
