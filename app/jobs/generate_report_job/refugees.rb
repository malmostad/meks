class GenerateReportJob
  class Refugees  < ApplicationJob
    queue_as :default

    def perform(params, file_id)
      filename = "#{file_id}.xlsx"
      refugees = refugees_query(params)
      create_workbook(refugees, params, filename)
    end

    private

    def create_workbook(refugees, params, filename)
      workbook = Report::Workbooks::Refugees.new
      report = Report::Generator.new(workbook, refugees, from: params[:refugees_registered_from], to: params[:refugees_registered_to])
      report.to_xlsx(filename)
    end

    def refugees_query(params)
      refugees = Refugee.includes(
        :countries, :languages, :ssns, :dossier_numbers,
        :gender, :homes, :municipality, :deregistered_reason,
        relationships: %i[type_of_relationship refugee],
        inverse_relationships: %i[type_of_relationship refugee],
        current_placements: [home: :type_of_housings]
      )

      if params[:refugees_registered_from].present? && params[:refugees_registered_to].present?
        refugees = refugees.where(registered: params[:refugees_registered_from]..params[:refugees_registered_to])
      end

      query = [(params[:refugees_born_after]..params[:refugees_born_before])]
      query << nil if params[:refugees_include_without_date_of_birth]

      if params[:refugees_born_after].present? && params[:refugees_born_before].present?
        refugees = refugees.where(date_of_birth: query)
      end

      if params[:refugees_asylum].present?
        query = []
        if params[:refugees_asylum].include? 'put'
          query << 'refugees.residence_permit_at is not null'
        end
        if params[:refugees_asylum].include? 'tut'
          query << 'refugees.temporary_permit_starts_at is not null'
        end
        if params[:refugees_asylum].include? 'municipality'
          query << 'refugees.municipality_id is not null'
        end
        refugees = refugees.where(query.join(' or '))
      end
      refugees
    end
  end
end
