# tareas que se ejecutan diariamente

require "typhoeus"
  
namespace :bazar do

 desc "Actualización de la información de la red"

 task :actualiza => :environment do |t|
   
   # inicializamos los contadores 
   puts "#{DateTime.now}: Actualización de la información."
   # ponemos a cero los contadores de perfiles y los actualizamos 
   # con la información local
   
   puts "#{DateTime.now} Perfiles: Actualizando contadores locales"
   
   @perfiles = Bazarcms::Perfil.all  
   for perfil in @perfiles

     total = Bazarcms::Perfil.count_by_sql("select count(*) from empresasperfiles where codigo = '#{perfil.codigo}'")  

     perfil.total_empresas_bazar = total
     perfil.total_empresas_mercado = total

     perfil.save 
     
   end 
   
   puts "#{DateTime.now} Perfiles: Actualizada información local de los perfiles"
   
   
   hydra = Typhoeus::Hydra.new
   
   puts "#{DateTime.now} Bazares: Empiezo a recolectar información de los bazares"
   
   micluster = Conf.find_by_nombre("BazarId")

   for cluster in Cluster.all
    
     if ( micluster != cluster.id && cluster.id != 1 )
             
       uri = "#{cluster.url}/api/perfiles.json"
       
       r = Typhoeus::Request.new(uri, :timeout => 5000)
       r.on_complete do |response|
         case response.curl_return_code
         when 0

           perfiles = JSON.parse(response.body)

           puts "#{perfiles.inspect} <-----------"

           perfiles.each{ |key|

             puts("#{key.inspect} esto es lo que hay")

             for ii in 0..key['id'].length-1
                if ii == 0
                  cod = "A"
                  puts "------> tenemos #{key['id'][0..0]} "
                  cod[0] = cod[0] + key['id'][0..0].to_i
                else 
                  cod = key['id'][0..ii]
                end 
                
               puts "Actualizando #{cod} + #{key['total_empresas_bazar'].to_i}"
               perfil = Bazarcms::Perfil.find_by_codigo(cod)
               perfil.total_empresas_mercado += key['total_empresas_bazar'].to_i
               perfil.save
               
             end

           }
         else
           puts "ERROR en la petición ---------->"+response.inspect
         end

       end

       hydra.queue r        
    
     end

   end 

   hydra.run

   puts "#{DateTime.now} Bazares: Fin del proceso"

 # fin tarea actualizar
 end


end
