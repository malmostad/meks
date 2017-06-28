class GenerateReportJob
  class EconomyPerTypeOfHousing < ApplicationJob
    queue_as :default

    def perform(params, file_id)
      workbook = Reports::EconomyPerTypeOfHousing.new(
        filename: "#{file_id}.xlsx",
        from: params[:placements_from],
        to: params[:placements_to]
      )
      workbook.create
    end
  end
end
