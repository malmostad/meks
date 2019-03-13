module EconomyReportHelper
  def payment(refugee, interval)
    sum_formula(::Economy::Payment.new(refugee.payments, interval).as_formula)
  end

  def payment_comments(refugee, interval)
    ::Economy::Payment.new(refugee.payments, interval).comments.join("\r\x0D\x0A")
  end

  def placement_names_within_range(refugee, interval)
    placements_within_range(refugee, interval).map do |pl|
      "#{pl.home.name} (#{pl.moved_in_at}–#{pl.moved_out_at})"
    end.join(', ')
  end

  def legal_codes_within_range(refugee, interval)
    placements_within_range(refugee, interval)
      .map(&:legal_code)
      .try(:map, &:name).join(', ')
  end

  # Filter out placements within the report range without add additional queries
  def placements_within_range(refugee, interval)
    refugee.placements.map do |placement|
      if placement.moved_in_at <= interval[:to].to_date &&
         (placement.moved_out_at.nil? || placement.moved_out_at >= interval[:from].to_date)
        next placement
      end
    end.compact.sort_by(&:moved_in_at)
  end
end
