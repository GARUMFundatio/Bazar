  namespace :ferret do
    desc "rebuid the ferret indexes"
    task :rebuild   => :environment do
      [Bazarcms::Empresa].each{|klass|
        puts "rebuilding the Ferret /#{RAILS_ENV}/ index for : 
#{klass}.."
        klass.rebuild_index
        puts "  done."
        }
    end
  end
