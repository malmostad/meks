module EconomyReportHelper
  def payment(person, interval)
    sum_formula(::Economy::Payment.new(person.payments, interval).as_formula)
  end

  def payment_comments(person, interval)
    ::Economy::Payment.new(person.payments, interval).comments.join("\r\x0D\x0A")
  end
end
