class Placement < ActiveRecord::Base
  attr_reader :placement_time

  default_scope { order(:moved_in_at) }

  belongs_to :refugee, touch: true
  belongs_to :home, touch: true
  belongs_to :moved_out_reason

  validates_presence_of :home
  validates_presence_of :moved_in_at

  before_validation do
    if moved_out_at.present? && moved_in_at > moved_out_at
      errors.add :moved_out_at, 'måste vara senare än inskrivningen'
    end
  end


  def self.overlapping_by_refugee(options = {})
    # Within range
    range_from = begin; Date.parse(options[:placements_from]).to_s; rescue; (Date.today - 10.years).to_s; end
    range_to   = begin; Date.parse(options[:placements_to]).to_s; rescue; Date.today.to_s; end

    # Single home or all
    select_home = options[:home_id].present? && options[:home_id].reject(&:empty?).present? ?
        "(A.home_id = #{options[:home_id].first} or B.home_id = #{options[:home_id].first})" : '1 = 1'

    # Select overlapping placements per refugee, within range, for home
    records = find_by_sql(["
      select A.* from placements A
      inner join placements B on
        (B.moved_in_at <= A.moved_out_at or A.moved_out_at is null)
        and (B.moved_out_at >= A.moved_in_at or B.moved_out_at is null)
      and ((B.moved_in_at  between ? and ?) or (A.moved_in_at between ? and ?))
      and ((A.moved_out_at between ? and ?) or A.moved_out_at is null)
      and ((B.moved_out_at between ? and ?) or B.moved_out_at is null)
      and ?
      and A.refugee_id = B.refugee_id
      and A.id <> B.id
      order by A.refugee_id",
      range_from, range_to, range_from, range_to,
      range_from, range_to, range_from, range_to, select_home])

    ActiveRecord::Associations::Preloader.new.preload(records,
      [:refugee, :home, :moved_out_reason, refugee: [:dossier_numbers, :ssns, :gender, :homes, :municipality, :countries, :languages, :relateds, :inverse_relateds],
      home: [:languages, :target_groups, :owner_type, :type_of_housings]])
    records
  end

  def self.current_placements
    where.not(moved_in_at: nil).where(moved_out_at: nil)
  end

  def self.current_quarter
    where('moved_out_at = ? or moved_in_at >= ?', nil, Date.today.beginning_of_quarter)
  end

  def placement_time
    return 0 if moved_in_at.blank?

    if moved_out_at.present?
      diff = moved_out_at - moved_in_at + 1
    else
      diff = DateTime.now.to_date - moved_in_at + 1
    end
    diff.to_i
  end
end
