puts "Inicializando el exception"

Bazar::Application.config.middleware.use "::ExceptionNotifier",
  :email_prefix => "[Bazar Garum] ",
  :sender_address => %{"Notifier" <juantomas@geofun.es>},
  :exception_recipients => %w{juantomas.garcia@gmail.com}

# Bazarcms::Application.config.middleware.use ::ExceptionNotifier,
#   :email_prefix => "[Bazar Garum] ",
#   :sender_address => %{"Notifier" <juantomas@geofun.es>},
#   :exception_recipients => %w{juantomas.garcia@gmail.com}
