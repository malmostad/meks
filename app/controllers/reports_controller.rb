class ReportsController < ApplicationController
  before_action :create_xlsx, except: [:index]

  def index
  end

  def placements
    @axlsx.workbook.add_worksheet do |sheet|
      sheet.add_row [
        'Barn',
        'Personnummer',
        'Dossiernummer',
        'Boende',
        'Placerad',
        'Utskriven',
        'Total placeringstid (dagar)',
        'Anledning till utskrivning',
        'Kommentar till utskrivning'
      ],
      style: @heading_style

      Placement.includes(
        :refugee, :home, :moved_out_reason, refugee: [:dossier_numbers, :ssns]).find_each do |placement|
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
          @cell_style,
          @cell_style,
          @cell_style,
          @cell_style,
          @date_format,
          @date_format,
          @cell_style,
          @cell_style,
          @wrap_style
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
    send_xlsx(@axlsx.to_stream.read, 'Placeringar')
  end

  def refugees
    @axlsx.workbook.add_worksheet do |sheet|
      sheet.add_row [
        'Namn',
        'Registrerad',
        'Avregistrerad',
        'Dossiernummer',
        'Personnummer',
        'Anvisad',
        'Kön',
        'Land',
        'Språk',
        'Aktuellt boenden',
        'All boenden',
        'Total placeringstid (dagar)'
      ], style: @heading_style

      Refugee.includes(
          :countries, :ssns, :dossier_numbers, :gender, :placements, :homes).find_each do |refugee|
        sheet.add_row([
          refugee.name,
          refugee.registered,
          refugee.deregistered,
          refugee.dossier_numbers.map(&:name).join(', '),
          refugee.ssns.map(&:name).join(', '),
          refugee.municipality.present? ? refugee.municipality.name : '',
          refugee.gender.present? ? refugee.gender.name : '',
          refugee.languages.map(&:name).join(', '),
          refugee.countries.map(&:name).join(', '),
          refugee.placements.where(moved_out_at: nil).map(&:home).map(&:name).join(', '),
          refugee.homes.map(&:name).join(', '),
          refugee.total_placement_time
        ],
        style: [
          @cell_style,
          @date_format,
          @date_format,
          @cell_style,
          @cell_style,
          @cell_style,
          @cell_style,
          @cell_style,
          @cell_style,
          @cell_style,
          @wrap_style,
          @cell_style
        ],
        types: [
          :string,
          :date,
          :date,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :string,
          :integer
        ])
        sheet.column_info.each { |c| c.width = 20 }
        sheet.column_info[6].width = 8
        sheet.column_info[10].width = 25
        sheet.column_info[11].width = 12
      end
    end
    send_xlsx(@axlsx.to_stream.read, 'Ensamkommand-barn')
  end

  private

  def create_xlsx
    @axlsx = Axlsx::Package.new

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
