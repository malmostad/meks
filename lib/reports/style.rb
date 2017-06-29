module Reports
  class Style
    def initialize(axlsx)
      @axlsx = axlsx
      @font = 'Calibri'
      @align_top = { vertical: :top }
    end

    def heading
      @axlsx.workbook.styles.add_style(heading_base_style)
    end

    def heading_with_tooltip
      @axlsx.workbook.styles.add_style(
        heading_base_style.merge!(
          border: { style: :thick, color: 'FF0000', edges: [:bottom] }
        )
      )
    end

    def normal
      @axlsx.workbook.styles.add_style(
        font_name: @font,
        fg_color: '000000',
        alignment: @align_top
      )
    end

    def link
      @axlsx.workbook.styles.add_style(
        font_name: @font,
        fg_color: '0066cc',
        alignment: @align_top
      )
    end

    def wrap
      @axlsx.workbook.styles.add_style(
        font_name: @font,
        fg_color: '000000',
        alignment: @align_top.merge(wrap_text: true)
      )
    end

    def date
      @axlsx.workbook.styles.add_style(
        font_name: @font,
        fg_color: '000000',
        alignment: @align_top,
        format_code: 'yyyy-mm-dd'
      )
    end

    def currency
      @axlsx.workbook.styles.add_style(
        font_name: @font,
        fg_color: '000000',
        alignment: @align_top,
        format_code: '# ##0'
      )
    end

    private

    def heading_base_style
      {
        font_name: @font,
        bg_color: '000000',
        fg_color: 'FFFFFF',
        alignment: @align_top,
        width: 10
      }
    end
  end
end
