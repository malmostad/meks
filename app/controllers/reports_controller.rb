class ReportsController < ApplicationController
  include ReportGenerator

  def index
  end

  def placements
    records = Placement.includes(
      :refugee, :home, :moved_out_reason, refugee: [:dossier_numbers, :ssns])
        .where(moved_in_at: params[:placements_from]..params[:placements_to])

    xlsx = generate_xlsx(:placements, records)
    send_xlsx xlsx, 'Placeringar'
  end

  def refugees
    records = Refugee.includes(
      :countries, :languages, :ssns, :dossier_numbers, :gender, :homes, :placements)

    xlsx = generate_xlsx(:refugees, records)
    send_xlsx xlsx, 'Ensamkommand-barn'
  end

  def homes
    records = Home.includes(
      :placements, :type_of_housings,
      :owner_types, :target_groups, :languages)

    xlsx = generate_xlsx(:homes, records)
    send_xlsx xlsx, 'Boenden'
  end
end
