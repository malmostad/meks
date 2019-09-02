class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def date_format(field_name)
    return unless errors.blank?
    unless start_date.is_a?(Date) && end_date.is_a?(Date)
      errors.add(field_name, 'Ogiltigt datumformat, ska vara yyyy-mm-dd')
    end
  end

  def date_range(field_name, from, to)
    return unless errors.blank?
    errors.add(field_name, 'Startdatum måste infalla innan slutdatum') if from >= to
  end

  # Rollback transaction if any record date ranges overlaps
  def validate_associated_date_overlaps(records, field_name)
    records.each do |r|
      if records.where.not(id: r.id).where('? <= end_date AND ? >= start_date', r.start_date, r.end_date).present?
        r.errors.add(field_name, 'Intervallet överlappar med ett annat')
        errors.add(:base)
        raise ActiveRecord::Rollback
      end
    end
  end
end
