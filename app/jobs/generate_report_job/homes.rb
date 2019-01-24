class GenerateReportJob
  class Homes < ApplicationJob
    def perform(params, file_id)
      workbook = HomesReport.new(
        filename: "#{file_id}.xlsx",
        owner_type: params[:homes_owner_type],
        free_seats: params[:homes_free_seats]
      )
      workbook.generate!
    end
  end
end
