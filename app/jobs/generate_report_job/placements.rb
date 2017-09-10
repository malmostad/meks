class GenerateReportJob
  class Placements < ApplicationJob
    def perform(params, file_id)
      Reports::Placements.new(
        filename: "#{file_id}.xlsx",
        selection: params[:placements_selection],
        home_id: params[:placements_home_id],
        from: params[:placements_from],
        to: params[:placements_to]
      ).create
    end
  end
end
