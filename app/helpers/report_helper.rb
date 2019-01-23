module ReportHelper
  def heading_comment(sheet, col, comment)
    sheet.add_comment(ref: "#{col}1", text: comment, author: '', visible: false)
  end
end
