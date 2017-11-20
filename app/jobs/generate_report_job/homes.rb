class GenerateReportJob
  class Homes < ApplicationJob
    def perform(params, file_id)
      workbook = Report::Homes.new(
        filename: "#{file_id}.xlsx",
        from: params[:placements_from],
        to: params[:placements_to],
        owner_type: params[:home_owner_type],
        free_seats: params[:homes_free_seats]
      )
      workbook.create!
    end
  end
end
