class GenerateReportJob
  class EconomyPerRefugeeStatus < ApplicationJob
    queue_as :default

    def perform(params, file_id)
      filename = "#{file_id}.xlsx"
      refugees = Refugee.in_arrival
      create_workbook(refugees, params, filename)
    end

    private

    def create_workbook(refugees, params, filename)
      from = params[:placements_from]
      to = params[:placements_to]
      workbook = Reports::EconomyPerRefugeeStatus.new(from: from, to: to)
      report = Report::Generator.new(workbook, refugees, from: from, to: to)
      report.to_xlsx(filename)
    end
  end
end
