namespace :reports do
  desc 'Cleanup reports directory'
  task cleanup: :environment do |task|
    FileUtils.rm_rf Dir.glob(File.join(reports_dir, '*'))
  end
end

def reports_dir
  File.join(Rails.root, 'reports')
end
