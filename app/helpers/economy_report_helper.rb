module EconomyReportHelper
  def payment(refugee, interval)
    sum_formula(::Economy::Payment.new(refugee.payments, interval).as_formula)
  end

  def payment_comments(refugee, interval)
    ::Economy::Payment.new(refugee.payments, interval).comments.join("\r\x0D\x0A")
  end
end
