require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Meks
  class Application < Rails::Application
    config.load_defaults 5.2
    config.active_record.belongs_to_required_by_default = false
    # config.log_formatter = Logger::Formatter.new
    # config.log_tags = [:some_var, :uuid, :remote_ip, lambda { |req| Time.now }]
    # config.log_tags = [ :subdomain, :uuid ]

    # Use a different logger for distributed setups.
    # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run 'rake -D time' for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Stockholm'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.available_locales = [:en, 'sv-SE'.to_sym, :sv]
    # config.i18n.available_locales = [:en, 'sv-SE'.to_sym, :sv, :sk, :fr, :sk, :de, :sk, :fi, :it, :nl, :pt, :vi]
    config.i18n.default_locale = 'sv'

    config.assets.paths += [
      Rails.root.join('vendor', 'malmo_shared_assets', 'stylesheets').to_s,
      Rails.root.join('vendor', 'malmo_shared_assets', 'stylesheets', 'shared').to_s,
      Rails.root.join('vendor', 'malmo_shared_assets', 'stylesheets', 'internal').to_s,
      Rails.root.join('vendor', 'chosen').to_s,
      Rails.root.join('vendor', 'bootstrap-additions').to_s
    ]

    config.active_job.queue_adapter = :delayed_job
  end
end
