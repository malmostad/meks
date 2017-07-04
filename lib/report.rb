require 'report/generator'
require 'report/style'
require 'report/workbooks'

class Report
  def self.format_asylum_status(h)
    return 'Ingen status' if h.blank?
    I18n.t('simple_form.labels.refugee.' + h.first) + ' ' + h.second.to_s
  end

  def self.numshort_date(date)
    I18n.l(date, format: :numshort) unless date.nil?
  end
end
