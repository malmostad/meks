require 'report_generator'

class GenerateReportJob < ApplicationJob
  queue_as :default

  def perform(params, file_id)
    filename = "#{file_id}.xlsx"
    self.send(params['report_type'], params, filename)
  end

  def placements(params, filename)
    records = Placement.includes(
      :refugee, :home, :moved_out_reason,
      refugee: [:countries, :languages, :ssns, :dossier_numbers,
                :gender, :homes, :placements, :municipality,
                :relateds, :inverse_relateds, :deregistered_reason],
      home: [:languages, :type_of_housings, :placements,
             :owner_type, :target_groups, :languages]
    ).within_range(params[:placements_from], params[:placements_to])

    # Selected one home or all
    if params[:placements_home_id].present? && params[:placements_home_id].reject(&:empty?).present?
      records = records.where(home_id: params[:placements_home_id])
    end

    # Only overlapping placements in time per refugee
    if params[:placements_selection] == 'overlapping'
      records = Placement.overlapping_by_refugee(params)
    end

    ReportGenerator.generate_xlsx(:placements, records, filename)
  end

  def refugees(params, filename)
    records = Refugee.includes(
      :countries, :languages, :ssns, :dossier_numbers,
      :gender, :homes, :municipality, :deregistered_reason,
      relationships: [:type_of_relationship, :refugee],
      inverse_relationships: [:type_of_relationship, :refugee],
      current_placements: [home: :type_of_housings])

    if params[:refugees_registered_from].present? && params[:refugees_registered_to].present?
      records = records.where(registered: params[:refugees_registered_from]..params[:refugees_registered_to])
    end

    query = [(params[:refugees_born_after]..params[:refugees_born_before])]
    query << nil if params[:refugees_include_without_date_of_birth]
    if params[:refugees_born_after].present? && params[:refugees_born_before].present?
      records = records.where(date_of_birth: query)
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
      records = records.where(query.join(' or '))
    end

    ReportGenerator.generate_xlsx(:refugees, records, filename)
  end

  def economy(params, filename)
    records = Refugee.includes(
      :dossier_numbers, :ssns,
      :municipality,
      :gender, :homes, :municipality,
      current_placements: [home: :type_of_housings]).where(
      registered: params[:refugees_registered_from]..params[:refugees_registered_to]
    )

    ReportGenerator.generate_xlsx(:economy, records, filename)
  end

  def homes(params, filename)
    records = Home.includes(
      :placements, :type_of_housings,
      :owner_type, :target_groups, :languages)

    if params[:homes_owner_type].present?
      records = records.where(owner_type: params[:homes_owner_type])
    end

    if params[:homes_free_seats] == 'with'
      records = records.each.reject { |r| r.free_seats <= 0 }
    end

    ReportGenerator.generate_xlsx(:homes, records, filename)
  end
end
