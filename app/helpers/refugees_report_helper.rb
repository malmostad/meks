module RefugeesReportHelper
  def asylum_status(refugee)
    asylum = refugee.asylum
    return 'Ingen status' if asylum.blank?

    I18n.t('simple_form.labels.refugee.' + asylum.first) + ' ' + asylum.second.to_s
  end
end
