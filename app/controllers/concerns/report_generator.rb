module ReportGenerator
  extend ActiveSupport::Concern

  included do
    def create_xlsx
      @axlsx = Axlsx::Package.new
      define_styles
    end

    def define_styles
      font_name = 'Calibri'
      align = { vertical: :top }

      @heading_style = @axlsx.workbook.styles.add_style(
        font_name: font_name,
        bg_color: '000000',
        fg_color: 'FFFFFF',
        alignment: align,
        width: 10
      )
      @cell_style = @axlsx.workbook.styles.add_style(
        font_name: font_name,
        fg_color: '000000',
        alignment: align,
      )
      @wrap_style = @axlsx.workbook.styles.add_style(
        font_name: font_name,
        fg_color: '000000',
        alignment: align.merge(wrap_text: true)
      )
      @date_format = @axlsx.workbook.styles.add_style(
        font_name: font_name,
        fg_color: '000000',
        alignment: align,
        format_code: 'yyyy-mm-dd'
      )
    end

    def generate_filename(base)
      "#{base}_#{DateTime.now.strftime('%Y-%m-%d_%H%M%S')}"
    end

    def send_xlsx(stream, name)
      send_data stream, type: :xlsx, disposition: "attachment",
        filename: "#{generate_filename(name)}.xlsx"
    end
  end

  module ClassMethods
  end
end
