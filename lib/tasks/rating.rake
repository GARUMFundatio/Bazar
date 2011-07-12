# tareas que se ejecutan diariamente


namespace :bazar do

 desc "Actualización de la información de la red"

 task :rating => :environment do |t|

   empresas = Bazarcms::Empresa.all
   bazar = Conf.find_by_nombre('BazarId').valor

   for empresa in empresas 
     
     puts "Recalculando #{bazar} empresa #{empresa.id}"
     rat = Bazarcms::Rating.new
     
     rat.calculo(bazar, empresa.id)
     
   end

 end


end
