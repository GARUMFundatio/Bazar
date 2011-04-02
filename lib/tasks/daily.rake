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
     perfil.total_empresas_bazar = 0
     perfil.total_empresas_mercado = 0
     perfil.save
   end

   for perfil in @perfiles

     total = Bazarcms::Perfil.count_by_sql("select count(distinct empresa_id) from empresasperfiles where codigo = '#{perfil.codigo}' order by empresa_id ")  

     if (total > 0) 

       for ii in 0..perfil.codigo.length-1
          if ii == 0
            cod = "A"
            cod[0] = cod[0] + perfil.codigo[0..0].to_i
          else 
            cod = perfil.codigo[0..ii]
          end 
           
           per = Bazarcms::Perfil.find_by_codigo(cod)
           puts "#{cod} tenia #{per.total_empresas_mercado} le sumo #{total}"
           per.total_empresas_bazar = total
           per.total_empresas_mercado = total
           per.save
       
       end

     end
     
   end 
   
   puts "#{DateTime.now} Perfiles: Actualizada información local de los perfiles"
   
   
   hydra = Typhoeus::Hydra.new
   
   puts "#{DateTime.now} Bazares: Empiezo a recolectar información de los bazares"
   
   micluster = Conf.find_by_nombre("BazarId").valor

   for cluster in Cluster.all
    
     puts "#{cluster.url} #{cluster.id} #{micluster}"
     if ( cluster.id != micluster && cluster.id != 1 )
       puts "#{cluster.url} #{cluster.id} #{micluster}"      
       uri = "#{cluster.url}/api/perfiles.json"
       puts "URI #{uri}"
       r = Typhoeus::Request.new(uri, :timeout => 5000)
       r.on_complete do |response|
         case response.curl_return_code
         when 0

           perfiles = JSON.parse(response.body)

           perfiles.each{ |key|
               
             perfil = Bazarcms::Perfil.find_by_codigo(key['id'])
             puts "#{key['id']} tenia #{perfil.total_empresas_mercado} le sumo #{key['total_empresas_bazar'].to_i} <--"
             perfil.total_empresas_mercado += key['total_empresas_bazar'].to_i
             perfil.save
           
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
