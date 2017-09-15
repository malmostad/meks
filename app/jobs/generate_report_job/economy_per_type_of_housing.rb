class GenerateReportJob
  class EconomyPerTypeOfHousing < ApplicationJob
    def perform(params, file_id)
      workbook = Report::EconomyPerTypeOfHousing.new(
        filename: "#{file_id}.xlsx",
        from: params[:placements_from],
        to: params[:placements_to]
      )
      workbook.create!
    end
  end
end
