class Placement < ActiveRecord::Base
  attr_reader :placement_time

  belongs_to :refugee
  belongs_to :home
  belongs_to :moved_out_reason

  validates_presence_of :home

  before_validation do
    if moved_out_at.present? && moved_in_at > moved_out_at
      errors.add :moved_out_at, 'måste vara senare än inskrivningen'
    end
  end


  def self.overlapping_by_refugee(options = {})
    # Limit to date range?
    range = begin
      "A.moved_in_at BETWEEN '#{Date.parse(options[:placements_from])}' AND '#{Date.parse(options[:placements_end])}'"
    rescue
      'true'
    end

    # Only for one home?
    home_id = options[:home_id].present? && options[:home_id].reject(&:empty?).present? ? "A.home_id = #{options[:home_id].first}" : 'true'

    # Select overlapping placements per refugee
    records = find_by_sql("
      select A.* from placements A
      inner join placements B on
        (B.moved_in_at <= A.moved_out_at or A.moved_out_at is null)
      and (B.moved_out_at >= A.moved_in_at or B.moved_out_at is null)
      and #{range}
      and #{home_id}
      and A.refugee_id = B.refugee_id
      and A.id <> B.id
      order by A.refugee_id")

    ActiveRecord::Associations::Preloader.new.preload(records, [:refugee, :home, :moved_out_reason, refugee: [:dossier_numbers, :ssns]])
    records
  end

  def placement_time
    if moved_out_at.present?
      diff = moved_out_at - moved_in_at
    else
      diff = DateTime.now.to_date - moved_in_at
    end
    diff.to_i
  end
end
