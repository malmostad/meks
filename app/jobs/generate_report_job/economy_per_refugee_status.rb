class GenerateReportJob
  class EconomyPerRefugeeStatus < ApplicationJob
    def perform(params, file_id)
      workbook = Report::EconomyPerRefugeeStatus.new(
        filename: "#{file_id}.xlsx",
        from: params[:economy_per_refugee_status_placements_from],
        to: params[:economy_per_refugee_status_placements_to]
      )
      workbook.create!
    end
  end
end
