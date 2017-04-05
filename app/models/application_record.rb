class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def date_format(field_name)
    return unless errors.blank?
    unless start_date.is_a?(Date) && end_date.is_a?(Date)
      errors.add(field_name, 'Ogiltigt datumformat, ska vara yyyy-mm-dd')
    end
  end

  def date_range(field_name)
    return unless errors.blank?
    if start_date >= end_date
      errors.add(field_name, 'Startdatum måste infalla innan slutdatum')
    end
  end

  # A rate period must not overlap with another
  def no_overlaps(field_name)
    return unless errors.blank?
    if siblings.where("? <= end_date AND ? >= start_date", start_date, end_date).present?
      errors.add(field_name, 'Intervallet överlappar med ett annat')
    end
  end
end
