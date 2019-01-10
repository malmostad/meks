class GenerateReportJob
  class Economy < ApplicationJob
    def perform(params, file_id)
      workbook = Report::Economy.new(
        filename: "#{file_id}.xlsx",
        from: params[:economy_placements_from],
        to: params[:economy_placements_to]
      )
      workbook.create!
    end
  end
end
