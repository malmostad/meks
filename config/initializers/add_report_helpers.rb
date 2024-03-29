# Add all report helpers to ActionView

helper_files = Dir.children(File.join(Rails.root, 'app', 'reports', 'helpers'))

Rails.application.reloader.to_prepare do
  helper_files.each do |helper_file|
    ActionView::Base.include Object.const_get(File.basename(helper_file, '.rb').camelize)
  end
end
