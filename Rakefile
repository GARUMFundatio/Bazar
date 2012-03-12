# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'metric_fu'

Bazar::Application.load_tasks

MetricFu::Configuration.run do |config|
        #define which metrics you want to use
        config.metrics  = [:churn, :saikuro, :stats, :flog, :flay]
        config.graphs   = [:flog, :flay, :stats]
end
