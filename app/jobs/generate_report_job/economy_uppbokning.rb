class GenerateReportJob
  class EconomyUppbokning < ApplicationJob
    def perform(params, file_id)
      workbook = Report::EconomyUppbokning.new(
        filename: "#{file_id}.xlsx",
        from: params[:economy_uppbokning_placements_from],
        to: params[:economy_uppbokning_placements_to],
        municipality: params[:municipality]
      )
      workbook.create!
    end
  end
end
