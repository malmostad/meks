require "#{Rails.root}/app/controllers/concerns/report_generator"
include ReportGenerator

namespace :reports do
  desc 'Generate report with all refugees not deregistered'
  task active_refugees: :environment do |task|
    active_refugees = Refugee.includes(
      :countries, :languages, :ssns, :dossier_numbers,
      :gender, :homes, :placements, :municipality,
      :relateds, :inverse_relateds,
      placements: :home).where(deregistered: nil)

    xlsx = generate_xlsx(:refugees, active_refugees)
    xlsx.serialize("#{reports_dir}/#{find_report(1)['filename']}")
  end

  desc 'Generate report with refugees registered this year or with placement on first of january'
  task refugees_this_year: :environment do |task|
    january_first = Date.today.beginning_of_year
    refugees_this_year = Refugee.joins(:placements).includes(
      :countries, :languages, :ssns, :dossier_numbers,
      :gender, :homes, :municipality, :relateds,
      :inverse_relateds, placements: :home).where(
      'registered >= ?
      or ((placements.moved_out_at >= ? or placements.moved_out_at is null)
      and placements.moved_in_at <= ?)',
      january_first, january_first, january_first).uniq

    xlsx = generate_xlsx(:refugees, refugees_this_year)
    xlsx.serialize("#{reports_dir}/#{find_report(2)['filename']}")
  end

  desc 'Generate all reports'
  task all: [:active_refugees, :refugees_this_year]
end

def reports_dir
  File.join(Rails.root, 'reports')
end

def find_report(id)
  APP_CONFIG['pre_generated_reports'].detect { |r| r['id'] == id.to_i }
end
