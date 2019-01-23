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
end
