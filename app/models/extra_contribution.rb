# "Övriga insatser"
class ExtraContribution < ApplicationRecord
  NUMERICALS = [Integer, Float, BigDecimal].freeze

  belongs_to :refugee, touch: true
  belongs_to :extra_contribution_type

  validates_presence_of :period_start, :period_end,
                        :extra_contribution_type_id, :refugee

  validate :numericality

  # Remove data not allowed for the extra_contribution_type used
  before_validation do
    if extra_contribution_type.special_case?
      %i[fee expense contactor_employee_number contractor_name contractor_birthday].each do |field|
        send("#{field}=", nil)
      end
    else
      %i[monthly_cost comment].each do |field|
        send("#{field}=", nil)
      end
    end
  end

  def numericality
    if extra_contribution_type.special_case?
      errors.add(:monthly_cost, 'är inte ett nummer') unless NUMERICALS.include? monthly_cost.class
    else
      %i[fee expense].each do |field|
        errors.add(field, 'är inte ett nummer') unless NUMERICALS.include? send(field).class
      end
    end
  end
end
