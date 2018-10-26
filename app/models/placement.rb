# 'Boendeplacering'
class Placement < ApplicationRecord
  belongs_to :refugee, touch: true
  belongs_to :home, touch: true
  belongs_to :moved_out_reason
  belongs_to :legal_code

  has_many :placement_extra_costs, dependent: :destroy
  accepts_nested_attributes_for :placement_extra_costs, allow_destroy: true, reject_if: :all_blank
  validates_associated :placement_extra_costs

  validates_presence_of :home
  validates_presence_of :refugee
  validates_presence_of :moved_in_at
  validates_presence_of :legal_code

  before_validation do
    if moved_out_at.present? && moved_in_at > moved_out_at
      errors.add :moved_out_at, 'måste vara senare än inskrivningen'
    end
  end

  # Remove data not allowed for the home the placement used
  before_save do
    self.specification = nil unless home.use_placement_specification?

    # Based on Home#type_of_cost
    placement_extra_costs.destroy_all unless home.cost_for_family_and_emergency_home?
    # TODO: add destroy_all for 'Familje/jourhemskostnaden' after implemented. => unless home.cost_for_family_and_emergency_home?
    self.cost = nil unless home.cost_per_placement?
  end

  def self.within_range(from, to)
    where('moved_in_at <= ?', to.to_date)
      .where('moved_out_at is ? or moved_out_at >= ?', nil, from.to_date)
  end

  def self.overlapping_by_refugee(from, to)
    # Within range
    range_from = begin; Date.parse(from).to_s; rescue; (Date.today - 10.years).to_s; end
    range_to   = begin; Date.parse(to).to_s; rescue; Date.today.to_s; end

    # Get and array of overlapping placements per refugee, within range, for home
    records = find_by_sql(["
      select A.id from placements A
      inner join placements B on
        (B.moved_in_at <= A.moved_out_at or A.moved_out_at is null)
        and (B.moved_out_at >= A.moved_in_at or B.moved_out_at is null)
      and ((B.moved_in_at  between ? and ?) or (A.moved_in_at between ? and ?))
      and ((A.moved_out_at between ? and ?) or A.moved_out_at is null)
      and ((B.moved_out_at between ? and ?) or B.moved_out_at is null)
      and A.refugee_id = B.refugee_id
      and A.id <> B.id
      order by A.refugee_id",
      range_from, range_to, range_from, range_to,
      range_from, range_to, range_from, range_to])

    # Return an ActiveRecord Relation
    where(id: records.map(&:id).uniq)
      .includes(:refugee, :home, :moved_out_reason, refugee: [:dossier_numbers, :ssns, :gender, :homes, :municipality, :countries, :languages, :relateds, :inverse_relateds],
      home: [:languages, :target_groups, :owner_type, :type_of_housings])
  end

  def self.current_placements
    where.not(moved_in_at: nil).where(moved_out_at: nil)
  end

  def self.current_quarter
    where('moved_out_at = ? or moved_in_at >= ?', nil, Date.today.beginning_of_quarter)
  end

  def placement_time
    return 0 if moved_in_at.blank?

    days = moved_out_at.present? ? (moved_out_at - moved_in_at).to_i : (Date.today - moved_in_at).to_i
    days + 1
  end

  def cost_per_day
    return 0 unless placement_time.positive?

    cost_sum / placement_time
  end

  def cost_sum
    Economy::Cost.for_placements_and_home([dup])
  end
end
