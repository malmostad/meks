class GenerateReportJob
  class EconomyFollowup < ApplicationJob
    def perform(params, file_id)
      workbook = EconomyFollowupReport.new(
        filename: "#{file_id}.xlsx",
        year: params[:economy_followup_years]
      )
      workbook.generate!
    end
  end
end
