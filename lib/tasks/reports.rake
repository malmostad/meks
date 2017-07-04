require 'report'

namespace :reports do
  desc 'Cleanup reports directory'
  task cleanup: :environment do |task|
    FileUtils.rm_rf Dir.glob(File.join(reports_dir, '*'))
  end

  desc 'Generate report with all refugees not deregistered'
  task active_refugees: :environment do |task|
    active_refugees = Refugee.includes(
      :countries, :languages, :ssns, :dossier_numbers,
      :gender, :homes, :placements, :municipality,
      :relateds, :inverse_relateds,
      placements: :home).where(deregistered: nil)

    ReportGenerator.generate_xlsx(:refugees, active_refugees, find_report(1)['filename'])
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

    ReportGenerator.generate_xlsx(:refugees, refugees_this_year, find_report(2)['filename'])
  end

  desc 'Placements for the current quarter'
  task placements_this_quarter: :environment do |task|
    placements_this_quarter = Placement.includes(
      :refugee, :home, :moved_out_reason,
      refugee: [:countries, :languages, :ssns, :dossier_numbers,
                :gender, :homes, :placements, :municipality,
                :relateds, :inverse_relateds],
      home: [:languages, :type_of_housings,
             :owner_type, :target_groups, :languages]).where(
        'moved_out_at is null or moved_out_at >= ?',
        Date.today.beginning_of_quarter)

    ReportGenerator.generate_xlsx(:placements, placements_this_quarter, find_report(3)['filename'])
  end

  desc 'All placements'
  task all_placements: :environment do |task|
    all_placements = Placement.includes(
      :refugee, :home, :moved_out_reason,
      refugee: [:countries, :languages, :ssns, :dossier_numbers,
                :gender, :homes, :placements, :municipality,
                :relateds, :inverse_relateds],
      home: [:languages, :type_of_housings,
             :owner_type, :target_groups, :languages]).all

    ReportGenerator.generate_xlsx(:placements, all_placements, find_report(4)['filename'])
  end

  desc 'Generate all reports'
  task all: [:active_refugees, :refugees_this_year, :placements_this_quarter, :all_placements]
end

def reports_dir
  File.join(Rails.root, 'reports')
end

def find_report(id)
  APP_CONFIG['pre_generated_reports'].detect { |r| r['id'] == id.to_i }
end
