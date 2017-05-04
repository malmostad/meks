class GenerateReportJob
  class Economy < ApplicationJob
    queue_as :default

    def perform(params, file_id)
      filename = "#{file_id}.xlsx"
      refugees = refugees_query(params)
      create_workbook(refugees, params, filename)
    end

    private

    def create_workbook(refugees, params, filename)
      from = params[:placements_from]
      to = params[:placements_to]
      workbook = Report::Workbooks::Economy.new(from: from, to: to)
      report = Report::Generator.new(workbook, refugees, from: from, to: to)
      report.to_xlsx(filename)
    end

    def refugees_query(params)
      Refugee.includes(
        :dossier_numbers, :ssns,
        :municipality,
        :gender, :homes, :municipality,
        current_placements: [home: :type_of_housings]
      ).where(registered: params[:placements_from]..params[:placements_to])
    end
  end
end
