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
        'Anledning till utskrivning',
        'Kommentar till utskrivning',
        'Total placeringstid (dagar)'
      ], style: @heading_style

      Placement.includes(
        :refugee, :home, :moved_out_reason, refugee: [:dossier_numbers, :ssns]).find_each do |placement|
        placement_data = [
          placement.refugee.name,
          placement.refugee.dossier_numbers.map(&:name).join(', '),
          placement.refugee.ssns.map(&:name).join(', '),
          placement.home.name,
          placement.moved_in_at,
          placement.moved_out_at,
          placement.moved_out_reason.present? ? placement.moved_out_reason.name : '',
          placement.comment,
          placement.placement_time
        ]
        sheet.add_row placement_data,
          style: [
            @body_style,
            @body_style,
            @body_style,
            @body_style,
            @date_format,
            @date_format,
            @body_style,
            @wrap,
            @body_style
          ],
          types: [
            :string,
            :string,
            :string,
            :string,
            :date,
            :date,
            :string,
            :string,
            :integer
          ]
      end
      sheet.column_info.each { |c| c.width = 20 }
      sheet.column_info[4].width = 12
      sheet.column_info[5].width = 12
      sheet.column_info[7].width = 40
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
        refugee_data = [
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
        ]
        sheet.add_row refugee_data,
          style: @body_style,
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
            :integer
          ]
      end
    end
    send_xlsx(@axlsx.to_stream.read, 'Ensamkommand-barn')
  end

  private

  def create_xlsx
    font_name = 'Calibri'
    align = { vertical: :top }

    @axlsx = Axlsx::Package.new

    @heading_style = @axlsx.workbook.styles.add_style(
      font_name: font_name,
      bg_color: '000000',
      fg_color: 'FFFFFF',
      alignment: align,
      width: 10
    )
    @body_style = @axlsx.workbook.styles.add_style(
      font_name: font_name,
      fg_color: '000000',
      alignment: align,
      width: 10
    )
    @wrap = @axlsx.workbook.styles.add_style(
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
