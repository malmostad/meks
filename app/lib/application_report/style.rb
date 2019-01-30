module ApplicationReport
  class Style
    attr_reader :top_border

    def initialize(axlsx)
      @axlsx = axlsx
      @font = 'Calibri'
      @align_top = { vertical: :top }
    end

    def heading
      @heading ||= @axlsx.workbook.styles.add_style(heading_base_style)
    end

    def heading_with_tooltip
      @heading_with_tooltip ||= @axlsx.workbook.styles.add_style(
        heading_base_style.merge!(
          border: { style: :thick, color: 'FF0000', edges: [:bottom] }
        )
      )
    end

    def normal
      @normal ||= @axlsx.workbook.styles.add_style(
        font_name: @font,
        fg_color: '000000',
        alignment: @align_top
      )
    end

    def sum
      @sum ||= @axlsx.workbook.styles.add_style(
        font_name: @font,
        fg_color: '000000',
        alignment: @align_top,
        format_code: '###&#32;###&#32;##0.00',
        border: { style: :thin, color: '000000', edges: %i[top] }
      )
    end

    def link
      @link ||= @axlsx.workbook.styles.add_style(
        font_name: @font,
        fg_color: '0066cc',
        alignment: @align_top
      )
    end

    def wrap
      @wrap ||= @axlsx.workbook.styles.add_style(
        font_name: @font,
        fg_color: '000000',
        alignment: @align_top.merge(wrap_text: true)
      )
    end

    def date
      @date ||= @axlsx.workbook.styles.add_style(
        font_name: @font,
        fg_color: '000000',
        alignment: @align_top,
        format_code: 'yyyy-mm-dd'
      )
    end

    def currency
      @currency ||= @axlsx.workbook.styles.add_style(
        font_name: @font,
        fg_color: '000000',
        alignment: @align_top,
        format_code: '###&#32;###&#32;##0.00'
      )
    end

    def heading_base_style
      @heading_base_style ||= {
        font_name: @font,
        bg_color: '000000',
        fg_color: 'FFFFFF',
        alignment: @align_top,
        width: 10,
        border: { style: :thin, color: 'FFFFFF', edges: %i[right bottom] }
      }
    end
  end
end
