# Load the rails application
require File.expand_path('../application', __FILE__)
require 'acts_as_ferret'


# Initialize the rails application
Bazar::Application.initialize!

# reseteamos el cache si hay un fork de Passenger

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    # Only works with DalliStore
    Rails.cache.reset if forked
    logger.debug "Dalli: forked reseteando memcached"
  end
end

