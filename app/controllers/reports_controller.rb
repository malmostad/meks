class ReportsController < ApplicationController

  def index
  end

  def placements
    axlsx = Axlsx::Package.new
    heading = axlsx.workbook.styles.add_style font_name: 'Calibri', bg_color: "000000", fg_color: "FFFFFF"
    body = axlsx.workbook.styles.add_style font_name: 'Calibri', fg_color: "000000"
    axlsx.workbook.add_worksheet do |sheet|
      sheet.add_row [
        'Person',
        'Boende',
        'Placerad',
        'Utskriven',
        'Anledning till utskrivning',
        'Kommentar till utskrivning',
        'Total placeringstid (dagar)'
      ], style: heading

      Placement.includes(
          :refugee, :home).find_each do |placement|
        placement_data = [
          placement.refugee.name,
          placement.moved_in_at,
          placement.moved_out_reason.present? ? placement.moved_out_reason.name : '',
          placement.comment,
          placement.placement_time
        ]
        sheet.add_row placement_data, style: body
      end
    end
    send_data axlsx.to_stream.read, type: :xlsx, disposition: "attachment", filename: "#{generate_filename(params)}.xlsx"
  end

  def refugees
    axlsx = Axlsx::Package.new
    heading = axlsx.workbook.styles.add_style font_name: 'Calibri', bg_color: "000000", fg_color: "FFFFFF"
    body = axlsx.workbook.styles.add_style font_name: 'Calibri', fg_color: "000000"
    axlsx.workbook.add_worksheet do |sheet|
      sheet.add_row [
        'Namn',
        'Registrerad',
        'Avregistrerad',
        'Dossiernummer',
        'Personnummer',
        'Kommunplacering',
        'Kön',
        'Land',
        'Språk',
        'Aktuellt boenden',
        'All boenden',
        'Total placeringstid (dagar)'
      ], style: heading

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
        sheet.add_row refugee_data, style: body
      end
    end
    send_data axlsx.to_stream.read, type: :xlsx, disposition: "attachment", filename: "#{generate_filename(params)}.xlsx"
  end

  def generate_filename(params)
    "#{params.except(:controller, :action, :format).map {|k,v| v }.join(" ")} #{Date.today.iso8601}"
  end
end
