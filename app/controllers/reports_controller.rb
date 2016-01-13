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
      records = Placement.includes(:refugee, :home, :moved_out_reason, refugee: [:dossier_numbers, :ssns])

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
      :countries, :languages, :ssns, :dossier_numbers, :gender, :homes, :placements)

    if params[:refugees_from].present? && params[:refugees_to].present?
      records = records.where(registered: params[:refugees_from]..params[:refugees_to])
    end

    xlsx = generate_xlsx(:refugees, records)
    send_xlsx xlsx, 'Ensamkommand-barn'
  end

  def homes
    records = Home.includes(
      :placements, :type_of_housings,
      :owner_types, :target_groups, :languages)

    if params[:homes_from].present? && params[:homes_to].present?
      records = records.where(created_at: params[:homes_from]..params[:homes_to])
    end

    xlsx = generate_xlsx(:homes, records)
    send_xlsx xlsx, 'Boenden'
  end
end
