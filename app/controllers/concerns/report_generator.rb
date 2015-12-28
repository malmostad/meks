module ReportGenerator
  extend ActiveSupport::Concern

  included do
    def generate_xlsx(template_name, records)
      @axlsx   = Axlsx::Package.new
      template = Template.new(@axlsx)

      template.send(template_name, records)
    end

    def send_xlsx(stream, base_name)
      send_data @axlsx.to_stream.read, type: :xlsx, disposition: "attachment",
        filename: "#{base_name}_#{DateTime.now.strftime('%Y-%m-%d_%H%M%S')}.xlsx"
    end

    class Template
      def initialize(axlsx)
        @axlsx = axlsx
        @style = Style.new(@axlsx)
      end

      def placements(records)
        @axlsx.workbook.add_worksheet do |sheet|
          sheet.add_row [
            'Barn',
            'Dossiernummer',
            'Personnummer',
            'Boende',
            'Placerad',
            'Utskriven',
            'Total placeringstid (dagar)',
            'Anledning till utskrivning',
            'Kommentar till utskrivning'
          ],
          style: @style.heading

          records.find_each do |placement|
            sheet.add_row([
              placement.refugee.name,
              placement.refugee.dossier_numbers.map(&:name).join(', '),
              placement.refugee.ssns.map(&:name).join(', '),
              placement.home.name,
              placement.moved_in_at,
              placement.moved_out_at,
              placement.placement_time,
              placement.moved_out_reason.present? ? placement.moved_out_reason.name : '',
              placement.comment
            ],
            style: [
              @style.normal,
              @style.normal,
              @style.normal,
              @style.normal,
              @style.date,
              @style.date,
              @style.normal,
              @style.normal,
              @style.wrap
            ],
            types: [
              :string,
              :string,
              :string,
              :string,
              :date,
              :date,
              :integer,
              :string,
              :string
            ])
          end
          sheet.column_info.each { |c| c.width = 20 }
          sheet.column_info[4].width = 12
          sheet.column_info[5].width = 12
          sheet.column_info[8].width = 40
        end
      end
    end

    class Style
      def initialize(axlsx)
        @axlsx = axlsx
        @font = 'Calibri'
        @align_top = { vertical: :top }
      end

      def heading
        @axlsx.workbook.styles.add_style(
          font_name: @font,
          bg_color: '000000',
          fg_color: 'FFFFFF',
          alignment: @align_top,
          width: 10
        )
      end

      def normal
        @axlsx.workbook.styles.add_style(
          font_name: @font,
          fg_color: '000000',
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
    end
  end

  module ClassMethods
  end
end
