require 'report'

class GenerateReportPlacementsJob < ApplicationJob
  queue_as :default

  def perform(params, file_id)
    filename = "#{file_id}.xlsx"
    placements = placements_query(params)
    create_workbook(placements, params, filename)
  end

  private

  def create_workbook(placements, params, filename)
    workbook = Report::Workbooks::Placements.new
    report = Report::Generator.new(workbook, placements, from: params[:placements_from], to: params[:placements_to])
    report.to_xlsx(filename)
  end

  def placements_query(params)
    placements = Placement.includes(
      :refugee, :home, :moved_out_reason,
      refugee: %i[countries languages ssns dossier_numbers
                  gender homes placements municipality
                  relateds inverse_relateds deregistered_reason],
      home: %i[languages type_of_housings placements
               owner_type target_groups languages]
    ).within_range(params[:placements_from], params[:placements_to])

    # Selected one home or all
    if params[:placements_home_id].present? && params[:placements_home_id].reject(&:empty?).present?
      placements = placements.where(home_id: params[:placements_home_id])
    end

    # Only overlapping placements in time per refugee
    if params[:placements_selection] == 'overlapping'
      placements = Placement.overlapping_by_refugee(params)
    end
    placements
  end
end
