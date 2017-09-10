class GenerateReportJob
  class Economy < ApplicationJob
    def perform(params, file_id)
      Reports::Economy.new(
        filename: "#{file_id}.xlsx",
        from: params[:placements_from],
        to: params[:placements_to]
      )
    end
  end
end
