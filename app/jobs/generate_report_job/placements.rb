class GenerateReportJob
  class Placements < ApplicationJob
    queue_as :default

    def perform(params, file_id)
      workbook = Reports::Placements.new(
        filename: "#{file_id}.xlsx",
        from: params[:placements_from],
        to: params[:placements_to],
        selection: params[:placements_selection],
        home_id: params[:placements_home_id]
      )
      workbook.create
    end
  end
end
