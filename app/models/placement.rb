class Placement < ApplicationRecord
  attr_reader :placement_time

  default_scope { order(:moved_in_at) }

  belongs_to :refugee, touch: true
  belongs_to :home, touch: true
  belongs_to :moved_out_reason
  belongs_to :legal_code

  validates_presence_of :home
  validates_presence_of :moved_in_at
  validates_presence_of :legal_code

  before_validation do
    if moved_out_at.present? && moved_in_at > moved_out_at
      errors.add :moved_out_at, 'måste vara senare än inskrivningen'
    end
  end

  def self.within_range(from, to)
    where('moved_in_at <= ?', to.to_date)
      .where('moved_out_at is ? or moved_out_at >= ?', nil, from.to_date)
  end

  def self.overlapping_by_refugee(from, to, home_id)
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

  def cost_sum
    costs = []
    if home.use_placement_cost
      costs << refugee.placement_cost(self)
    else
      costs << refugee.placement_home_costs(self)
    end

    cost = 0
    costs.flatten.each do |c|
      cost += c[:cost] * c[:days]
    end
    cost
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
end
