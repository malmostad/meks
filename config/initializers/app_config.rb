APP_CONFIG = YAML.load(ERB.new(File.read("#{Rails.root.to_s}/config/app_config.yml")).result)[Rails.env]
