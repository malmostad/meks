# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store,
    key:      '_meks_session',
    secure:   Rails.env.production? || Rails.env.test?,
    httponly: true
