class GenerateReportJob
  class Economy < ApplicationJob
    def perform(params, file_id)
      workbook = Reports::Economy.new(
        filename: "#{file_id}.xlsx",
        from: params[:placements_from],
        to: params[:placements_to]
      )
      workbook.create!
    end
  end
end
