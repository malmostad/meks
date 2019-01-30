module PlacementsReportHelper
  def within_range(placement, interval)
    placement.refugee.placements_within(interval[:from], interval[:to]).sort_by(&:moved_in_at)
  end
end
