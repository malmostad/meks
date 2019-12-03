class ReportsController < ApplicationController
  skip_authorize_resource
  skip_authorization_check
  before_action { authorize! :generate, :reports }

  def index
    @homes = Home.order(:name)

    # Used for form select
    @our_municipalities = { 'Alla i Malmö stad' => 'all' }
    Municipality.where(our_municipality: true).each do |municipality|
      @our_municipalities[municipality.name] = municipality.id
    end
  end

  def generate
    file_id = SecureRandom.hex
    job = generate_report_job(file_id)
    delayed_job_id = Delayed::Job.find(job.provider_job_id).id

    redirect_to reports_status_path(delayed_job_id, file_id, params[:report_type])
  end

  def status
    job = Delayed::Job.where(id: params[:job_id]).first

    if !job && File.exist?(file_path("#{params[:file_id]}.xlsx"))
      finished = true
    elsif !job # No job and no file found,
      raise ActionController::RoutingError.new('Not Found')
    else
      finished = false
      failed = job.failed_at ? true : false
      created_at = job.created_at.to_i
      queue_size = Delayed::Job.where(last_error: nil).count
      queue_size = 'du är först i kön' if queue_size.nil? || queue_size <= 1
    end

    @status = {
      file_id: params[:file_id],
      created_at: created_at || 0,
      finished: finished,
      failed: failed,
      queue_size: queue_size,
      status_url: reports_status_url(params[:job_id], params[:file_id]),
      report_type: params[:report_type]
    }

    respond_to do |format|
      format.html
      format.json do
        render json: @status
      end
    end
  end

  def download
    file_with_path = file_path("#{params[:id]}.xlsx")

    if File.exist? file_with_path
      response.headers['Content-Length'] = File.size(file_with_path).to_s
      send_xlsx file_with_path, "#{report_name_prefix}_#{Time.now.strftime('%Y-%m-%d_%H%M%S')}.xlsx"
    else
      render :report_not_found
    end
  end

  private

  def report_params
    params.permit(
      :homes_free_seats,
      :homes_owner_type,
      :placements_from,
      :placements_to,
      :economy_followup_year,
      :economy_uppbokning_placements_from,
      :economy_uppbokning_placements_to,
      :economy_placements_to,
      :economy_placements_from,
      :placements_selection,
      :people_born_after,
      :people_born_before,
      :people_include_without_date_of_birth,
      :people_registered_from,
      :people_registered_to,
      :municipality,
      :report_type,
      placements_home_id: [],
      people_asylum: []
    )
  end

  def send_xlsx(file_with_path, base_name)
    send_file file_with_path, type: :xlsx, disposition: 'attachment', filename: base_name
  end

  def file_path(filename)
    filename = sanitize_filename(filename)
    File.join(Rails.root, 'reports', filename)
  end

  def generate_report_job(file_id)
    case params[:report_type]
    when 'economy'
      GenerateReportJob::Economy.perform_later(report_params.to_h, file_id)
    when 'economy_uppbokning'
      GenerateReportJob::EconomyUppbokning.perform_later(report_params.to_h, file_id)
    when 'economy_followup'
      GenerateReportJob::EconomyFollowup.perform_later(report_params.to_h, file_id)
    when 'homes'
      GenerateReportJob::Homes.perform_later(report_params.to_h, file_id)
    when 'placements'
      GenerateReportJob::Placements.perform_later(report_params.to_h, file_id)
    when 'people'
      GenerateReportJob::People.perform_later(report_params.to_h, file_id)
    end
  end

  def report_name_prefix
    case params[:report_type]
    when 'economy'
      'Ekonomi'
    when 'economy_uppbokning'
      'Ekonomi uppbokning'
    when 'economy_followup'
      'Ekonomi prognos'
    when 'homes'
      'Boenden'
    when 'placements'
      'Placeringar'
    when 'people'
      'Personer'
    end
  end

  # From http://guides.rubyonrails.org/security.html
  def sanitize_filename(filename)
    filename.strip.tap do |name|
      name.sub!(/\A.*(\\|\/)/, '')
      # Replace all non alphanumeric, underscore
      # or periods with underscore
      name.gsub!(/[^\w\.\-]/, '_')
    end
  end
end
