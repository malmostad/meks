class ReportsController < ApplicationController
  skip_authorize_resource
  skip_authorization_check
  before_action { authorize! :generate, :reports }

  include ReportGenerator

  def index
    @homes = Home.order(:name)
  end

  def placements
    if params[:placement_selection] == 'overlapping'
      records = Placement.overlapping_by_refugee(params)
    else
      records = Placement.includes(
        :refugee, :home, :moved_out_reason,
        refugee: [:countries, :languages, :ssns, :dossier_numbers,
          :gender, :homes, :placements, :municipality,
          :relateds, :inverse_relateds],
        home: [:placements, :type_of_housings,
          :owner_type, :target_groups, :languages])

      if params[:placements_from].present? && params[:placements_to].present?
        records = records.where(moved_in_at: params[:placements_from]..params[:placements_to])
      end

      if params[:placements_home].present?
        records = records.where(home_id: params[:placements_home])
      end

      # Selected one home or all
      if params[:home_id].reject(&:empty?).present?
        records = records.where(home_id: params[:home_id])
      end
    end

    xlsx = generate_xlsx(:placements, records)
    send_xlsx xlsx, 'Placeringar'
  end

  def refugees
    records = Refugee.includes(
      :countries, :languages, :ssns, :dossier_numbers,
      :gender, :homes, :placements, :municipality,
      :relateds, :inverse_relateds)

    if params[:refugees_registered_from].present? && params[:refugees_registered_to].present?
      records = records.where(registered: params[:refugees_registered_from]..params[:refugees_registered_to])
    end

    dob_selection = [(params[:refugees_born_after]..params[:refugees_born_before])]
    dob_selection << nil if params[:refugees_include_without_date_of_birth]
    if params[:refugees_born_after].present? && params[:refugees_born_before].present?
      records = records.where(date_of_birth: dob_selection)
    end

    xlsx = generate_xlsx(:refugees, records)
    send_xlsx xlsx, 'Ensamkommand-barn'
  end

  def homes
    records = Home.includes(
      :placements, :type_of_housings,
      :owner_type, :target_groups, :languages)

    if params[:homes_from].present? && params[:homes_to].present?
      records = records.where(created_at: params[:homes_from]..params[:homes_to])
    end

    xlsx = generate_xlsx(:homes, records)
    send_xlsx xlsx, 'Boenden'
  end
end
