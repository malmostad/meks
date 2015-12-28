class ReportsController < ApplicationController
  include ReportGenerator

  def index
  end

  def placements
    records = Placement.includes(
      :refugee, :home, :moved_out_reason, refugee: [:dossier_numbers, :ssns])

    send_xlsx generate_xlsx(:placements, records), 'Placeringar'
  end

  # def refugees
  #   @axlsx.workbook.add_worksheet do |sheet|
  #     sheet.add_row [
  #       'Namn',
  #       'Registrerad',
  #       'Avregistrerad',
  #       'Dossiernummer',
  #       'Personnummer',
  #       'Anvisad',
  #       'Kön',
  #       'Land',
  #       'Språk',
  #       'Aktuellt boenden',
  #       'All boenden',
  #       'Total placeringstid (dagar)'
  #     ], style: @style.heading
  #
  #     Refugee.includes(
  #         :countries, :languages, :ssns, :dossier_numbers, :gender, :homes, :placements).find_each do |refugee|
  #       sheet.add_row([
  #         refugee.name,
  #         refugee.registered,
  #         refugee.deregistered,
  #         refugee.dossier_numbers.map(&:name).join(', '),
  #         refugee.ssns.map(&:name).join(', '),
  #         refugee.municipality.present? ? refugee.municipality.name : '',
  #         refugee.gender.present? ? refugee.gender.name : '',
  #         refugee.languages.map(&:name).join(', '),
  #         refugee.countries.map(&:name).join(', '),
  #         refugee.placements.where(moved_out_at: nil).map(&:home).map(&:name).join(', '),
  #         refugee.homes.map(&:name).join(', '),
  #         refugee.total_placement_time
  #       ],
  #       style: [
  #         @style.normal,
  #         @style.date_format,
  #         @style.date_format,
  #         @style.normal,
  #         @style.normal,
  #         @style.normal,
  #         @style.normal,
  #         @style.normal,
  #         @style.normal,
  #         @style.normal,
  #         @style.wrap,
  #         @style.normal
  #       ],
  #       types: [
  #         :string,
  #         :date,
  #         :date,
  #         :string,
  #         :string,
  #         :string,
  #         :string,
  #         :string,
  #         :string,
  #         :string,
  #         :string,
  #         :integer
  #       ])
  #       sheet.column_info.each { |c| c.width = 20 }
  #       sheet.column_info[6].width = 8
  #       sheet.column_info[10].width = 25
  #       sheet.column_info[11].width = 12
  #     end
  #   end
  #   send_xlsx(@axlsx.to_stream.read, 'Ensamkommand-barn')
  # end
end
