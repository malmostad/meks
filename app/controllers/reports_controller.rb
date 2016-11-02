class ReportsController < ApplicationController
  skip_authorize_resource
  skip_authorization_check
  before_action { authorize! :generate, :reports }

  def index
    @homes = Home.order(:name)
    @pre_generated_reports = pre_generated_reports
  end

  def generate
    file_id = SecureRandom.hex
    job = GenerateReportJob.perform_later(params, file_id)
    delayed_job_id = Delayed::Job.find(job.provider_job_id).id

    redirect_to reports_status_path(delayed_job_id, file_id)
  end

  def status
    job = Delayed::Job.where(id: params[:job_id]).first

    if !job && File.exist?(file_path("#{params[:file_id]}.xlsx"))
      finished = true
    elsif !job # No job and no file found,
      raise ActionController::RoutingError.new('Not Found')
    else
      finished = false
      created_at = job.created_at.to_i
      queue_size = Delayed::Job.where(last_error: nil).count - 1
      queue_size = 'du är först i kön' if queue_size.nil? || queue_size <= 1
    end

    @status = {
      file_id: params[:file_id],
      created_at: created_at || 0,
      finished: finished,
      queue_size: queue_size,
      status_url: reports_status_url(params[:job_id], params[:file_id])
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
      send_xlsx file_with_path, "#{current_user.username}_#{Time.now.to_formatted_s(:number)}.xlsx"
    else
      render :report_not_found
    end
  end

  def download_pre_generated
    filename = pre_generated_report_name(params[:id])['filename']
    file_with_path = file_path(filename)

    send_xlsx file_with_path, filename
  end

  private

  def pre_generated_reports
    APP_CONFIG['pre_generated_reports'].each do |report|
      file = file_path(report['filename'])

      if File.exist?(file)
        report.merge!(
          filetime: File.mtime(file).localtime,
          filesize: File.size(file)
        )
      end
    end
  end

  def send_xlsx(file_with_path, base_name)
    send_file file_with_path, type: :xlsx, disposition: 'attachment',
      filename: "#{base_name}.xlsx"
  end

  def file_path(filename)
    filename = sanitize_filename(filename)
    File.join(Rails.root, 'reports', filename)
  end

  def pre_generated_report_name(id)
    APP_CONFIG['pre_generated_reports'].detect { |r| r['id'] == id.to_i }
  end

  # From http://guides.rubyonrails.org/security.html
  def sanitize_filename(filename)
    filename.strip.tap do |name|
      # get only the fil
      name.sub! /\A.*(\\|\/)/, ''
      # Replace all non alphanumeric, underscore
      # or periods with underscore
      name.gsub! /[^\w\.\-]/, '_'
    end
  end
end
