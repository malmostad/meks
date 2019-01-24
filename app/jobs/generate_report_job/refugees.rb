class GenerateReportJob
  class Refugees < ApplicationJob
    def perform(params, file_id)
      workbook = RefugeesReport.new(
        filename: "#{file_id}.xlsx",
        registered_from: params[:refugees_registered_from],
        registered_to: params[:refugees_registered_to],
        born_after: params[:refugees_born_after],
        born_before: params[:refugees_born_before],
        include_without_date_of_birth: params[:refugees_include_without_date_of_birth],
        asylum: params[:refugees_asylum]
      )
      workbook.generate!
    end
  end
end
