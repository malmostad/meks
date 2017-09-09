class GenerateReportJob
  class Economy < ApplicationJob
    def perform(params, file_id)
      @from = params[:placements_from]
      @to = params[:placements_to]
      filename = "#{file_id}.xlsx"
      refugees = refugees_query
      create_workbook(refugees, filename)
    end

    private

    def create_workbook(refugees, filename)
      workbook = Report::Workbooks::Economy.new(from: @from, to: @to)
      report = Report::Generator.new(workbook, refugees, from: @from, to: @to)
      report.to_xlsx(filename)
    end

    def refugees_query
      Refugee.includes(
        :dossier_numbers, :ssns,
        :municipality, :payments, :gender,
        placements: [:legal_code, { home: %i[type_of_housings costs] }]
      ).with_placements_within(@from, @to)
    end
  end
end
