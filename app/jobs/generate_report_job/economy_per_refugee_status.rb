class GenerateReportJob
  class EconomyPerRefugeeStatus < ApplicationJob
    def perform(params, file_id)
      workbook = Report::EconomyPerRefugeeStatus.new(
        filename: "#{file_id}.xlsx",
        from: params[:placements_from],
        to: params[:placements_to]
      )
      workbook.create!
    end
  end
end
