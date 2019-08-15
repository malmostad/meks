class GenerateReportJob
  class People < ApplicationJob
    def perform(params, file_id)
      workbook = PeopleReport.new(
        filename: "#{file_id}.xlsx",
        registered_from: params[:people_registered_from],
        registered_to: params[:people_registered_to],
        born_after: params[:people_born_after],
        born_before: params[:people_born_before],
        include_without_date_of_birth: params[:people_include_without_date_of_birth],
        asylum: params[:people_asylum]
      )
      workbook.generate!
    end
  end
end
