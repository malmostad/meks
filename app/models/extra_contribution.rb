# "Insatser"
class ExtraContribution < ApplicationRecord
  NUMERICALS = [Integer, Float, BigDecimal].freeze

  belongs_to :person, touch: true
  belongs_to :extra_contribution_type

  validates_presence_of :period_start, :period_end,
                        :extra_contribution_type_id, :person

  validates :monthly_cost, numericality: true, if: :outpatient?
  validates :fee, numericality: true, unless: :outpatient?
  validates :expense, numericality: true, allow_blank: true, unless: :outpatient?

  # Remove data not allowed for the extra_contribution_type used
  before_validation do
    if extra_contribution_type&.outpatient?
      %i[fee expense contactor_employee_number contractor_name contractor_birthday].each do |field|
        send("#{field}=", nil)
      end
    else
      %i[monthly_cost comment].each do |field|
        send("#{field}=", nil)
      end
    end
  end

  def outpatient?
    extra_contribution_type&.outpatient?
  end
end
