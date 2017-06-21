class GenerateReportJob
  class Economy < ApplicationJob
    queue_as :default

    def perform(params, file_id)
      filename = "#{file_id}.xlsx"
      from     = params[:placements_from]
      to       = params[:placements_to]

      workbook = Report::Workbooks::Economy.new(filename: filename, from: from, to: to)
      workbook.create
    end
  end
end
