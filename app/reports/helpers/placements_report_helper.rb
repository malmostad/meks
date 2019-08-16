module PlacementsReportHelper
  def within_range(placement, interval)
    placement.person.placements_within(interval[:from], interval[:to]).sort_by(&:moved_in_at)
  end
end
