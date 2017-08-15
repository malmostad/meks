class GenerateReportJob
  class Economy < ApplicationJob
    queue_as :default

    def perform(params, file_id)
      @from = params[:placements_from]
      @to = params[:placements_to]
      filename = "#{file_id}.xlsx"
      refugees = refugees_query(params)
      create_workbook(refugees, filename)
    end

    private

    def create_workbook(refugees, filename)
      workbook = Report::Workbooks::Economy.new(from: @from, to: @to)
      report = Report::Generator.new(workbook, refugees, from: @from, to: @to)
      report.to_xlsx(filename)
    end

    def refugees_query
      Refugee.includes(placements: { home: :type_of_housings }).with_placements_within(@from, @to)
    end
  end
end
