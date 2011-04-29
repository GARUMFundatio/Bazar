# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Bazar::Application


Whatever::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[Bazar Garum] ",
  :sender_address => %{"Bazar Garum" <juanto@bazargarum.org>},
  :exception_recipients => %w{juantomas.garcia@gmail.com}
