class GenerateReportJob
  class Placements < ApplicationJob
    def perform(params, file_id)
      Reports::Placements.new(
        filename: "#{file_id}.xlsx",
        placements_selection: params[:selection],
        placements_home_id: params[:home_id],
        placements_from: params[:from],
        placements_to: params[:to]
      ).create
    end
  end
end
