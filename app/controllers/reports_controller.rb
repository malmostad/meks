class ReportsController < ApplicationController
  # FIXME: set auth correctly in Ability
  skip_authorize_resource
  skip_authorization_check
  before_action { authorize! :generate, :reports }

  def index
    @homes = Home.order(:name)
    @pre_generated_reports = pre_generated_reports
  end

  def placements
    queue_job('placements', params)
    render plain: "Job id: #{@delayed_job_id} File id: #{@file_id}"
  end

  def refugees
    queue_job('refugees', params)
    render plain: "Job id: #{@delayed_job_id} File id: #{@file_id}"
  end

  def homes
    queue_job('homes', params)
    render plain: "Job id: #{@delayed_job_id} File id: #{@file_id}"
  end

  def status(job_id)
    job_id
  end

  def downloads
    filename = find_report(params[:id].to_i)
    send_file report_filepath(filename), type: :xlsx, disposition: 'attachment', filename: filename
  end

  private

  def queue_job(report_type, params)
    @file_id = "#{@current_user.username}_#{Time.now.to_f}".delete('.')

    job = GenerateReportJob.perform_later(report_type, params, @file_id)
    @delayed_job_id = Delayed::Job.find(job.provider_job_id).id
  end

  def pre_generated_reports
    APP_CONFIG['pre_generated_reports'].each do |report|
      filepath = report_filepath(report['filename'])

      if File.exist?(filepath)
        report.merge!(
          filetime: File.mtime(filepath).localtime,
          filesize: File.size(filepath)
        )
      end
    end
  end

  def report_filepath(filename)
    File.join(Rails.root, 'reports', filename)
  end

  def find_report(id)
    APP_CONFIG['pre_generated_reports'].detect { |r| r['id'] == id.to_i }
  end

  def send_xlsx(xlsx, base_name)
    send_data xlsx.to_stream.read, type: :xlsx, disposition: 'attachment',
      filename: "#{base_name}.xlsx"
  end
end
