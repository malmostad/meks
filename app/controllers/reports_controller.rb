class ReportsController < ApplicationController
  include ReportGenerator

  def index
  end

  def placements
    records = Placement.includes(
      :refugee, :home, :moved_out_reason, refugee: [:dossier_numbers, :ssns])

    send_xlsx generate_xlsx(:placements, records), 'Placeringar'
  end

  def refugees
    records = Refugee.includes(
        :countries, :languages, :ssns, :dossier_numbers, :gender, :homes, :placements)

    send_xlsx generate_xlsx(:refugees, records), 'Ensamkommand-barn'
  end
end
