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
    GenerateReportJob.perform_later(params, file_id)

    write_cookie(file_id)

    redirect_to reports_status_path
  end

  def status
    report = read_cookie

    if report.present? && report['file_id'].present?
      valid = true
      finished = File.exist?(file_path("#{report['file_id']}.xlsx"))
    else
      valid = false
    end

    @status = {
      file_id: report['file_id'],
      created_at: report['created_at'],
      finished: finished,
      valid: valid,
      queue_size: Delayed::Job.where(last_error: nil).count
    }

    respond_to do |format|
      format.html
      format.json do
        render json: @status
      end
    end
  end

  def download
    filename = "#{params[:id]}.xlsx"
    file = file_path(filename)

    if File.exist? file
      send_xlsx file, filename
    else
      render :report_not_found
    end
  end

  def download_pre_generated
    filename = pre_generated_report_name(params[:id])['filename']
    file = file_path(filename)

    send_xlsx send_xlsx file, filename
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

  def send_xlsx(xlsx, base_name)
    send_data xlsx.to_stream.read, type: :xlsx, disposition: 'attachment',
      filename: "#{base_name}.xlsx"
  end

  def file_path(filename)
    filename = sanitize_filename(filename)
    File.join(Rails.root, 'reports', filename)
  end

  def write_cookie(file_id)
    cookies[:report] = {
      value: JSON.generate(
        file_id: file_id,
        created_at: Time.now.to_i
      ),
      secure: Rails.env.production? || Rails.env.test?,
      domain: request.host,
      expires: 10.hour.from_now
    }
  end

  def read_cookie
    report = cookies[:report]
    JSON.parse(report) if report
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
