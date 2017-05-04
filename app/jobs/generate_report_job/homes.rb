class GenerateReportJob
  class Homes  < ApplicationJob
    queue_as :default

    def perform(params, file_id)
      filename = "#{file_id}.xlsx"
      homes = homes_query(params)
      create_workbook(homes, filename)
    end

    private

    def create_workbook(homes, filename)
      workbook = Report::Workbooks::Homes.new
      report = Report::Generator.new(workbook, homes)
      report.to_xlsx(filename)
    end

    def homes_query(params)
      homes = Home.includes(
        :placements, :type_of_housings,
        :owner_type, :target_groups, :languages
      )

      if params[:homes_owner_type].present?
        homes = homes.where(owner_type: params[:homes_owner_type])
      end

      if params[:homes_free_seats] == 'with'
        homes = homes.each.reject { |r| r.free_seats <= 0 }
      end
      homes
    end
  end
end
