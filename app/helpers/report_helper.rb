module ReportHelper
  def heading_comment(sheet, col, comment)
    sheet.add_comment(ref: "#{col}1", text: comment, author: '', visible: false)
  end

  def sum_formula(*arr)
    arr.flatten!
    arr&.reject!(&:blank?)
    return '=(0)' if arr.blank?

    "=(#{arr.join('+')})"
  end

  def asylum_status(refugee)
    asylum = refugee.asylum
    return 'Ingen status' if asylum.blank?

    I18n.t('simple_form.labels.refugee.' + asylum.first) + ' ' + asylum.second.to_s
  end
end
