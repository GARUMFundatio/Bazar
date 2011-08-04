# tareas que se ejecutan diariamente

require "typhoeus"
  
namespace :bazar do

 desc "Actualización de la información de la red"

 task :actualiza => :environment do |t|

   puts "#{DateTime.now}: Actualización de la información."
   
   # Actualizamos la lista de clusters

   puts "#{DateTime.now}: Bazares: Actualizamos la información de bazares."
   uri = "http://directorio.garumfundatio.org/clusters.json"
   hydra = Typhoeus::Hydra.new

    r = Typhoeus::Request.new(uri, :timeout => 10000)
    r.on_complete do |response|
      case response.curl_return_code
      when 0
        clusters = JSON.parse(response.body)
        # puts ("#{clusters.inspect} <---------")

        clusters.each{ |key|
          # puts ("#{key.inspect}")
          # puts ("#{key['cluster'].inspect} <------ datos")
          # puts ("#{key['cluster']['id']}")

          cluster = Cluster::find_by_id(key['cluster']['id'])
          if (cluster == nil)
            # puts ("nuevo cluster #{key['cluster']['id']}")
            cluster = Cluster::new
            cluster.id = key['cluster']['id']
            cluster.nombre = key['cluster']['nombre']
            cluster.desc = key['cluster']['desc']
            cluster.empresas = key['cluster']['empresas']
            cluster.url = key['cluster']['url']
            cluster.activo = 'S'
            cluster.miclave = 'secreta'
            cluster.suclave = 'secreta'
            cluster.created_at = key['cluster']['created_at']
            cluster.updated_at = key['cluster']['updated_at']         
            cluster.save
          else
            # puts ("actualizo cluster #{key['cluster']['id']}")
            cluster.nombre = key['cluster']['nombre']
            cluster.desc = key['cluster']['desc']
            cluster.empresas = key['cluster']['empresas']
            cluster.url = key['cluster']['url']
            cluster.updated_at = key['cluster']['updated_at']         
            cluster.save          
          end

        }

      else
        puts "ERROR en la petición ---------->"+response.inspect
      end
    
    end
    
    hydra.queue r        
    hydra.run

    puts "#{DateTime.now} Bazares: Lista Actualizada"
   
   # inicializamos los contadores 
  
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
           per.total_empresas_bazar = total
           per.total_empresas_mercado = total
           per.save
       
       end

     end
     
   end 
   
   puts "#{DateTime.now} Perfiles: Actualizada información local de los perfiles"

   puts "#{DateTime.now} Países: Actualizando contadores locales"
   
   @paises = Bazarcms::Pais.all  

   for pais in @paises
     pais.total_empresas_bazar = 0
     pais.total_empresas_mercado = 0
     pais.save
   end

   for pais in @paises

     total = Bazarcms::Perfil.count_by_sql("select count(distinct(ubicaciones.empresa_id)) from ubicaciones, ciudades where ubicaciones.ciudad_id = ciudades.id and ciudades.pais_id = #{pais.id} order by ubicaciones.empresa_id ")  

     if (total > 0) 
         # puts "Actualizo País ---> #{pais.descripcion} con #{total}"
         pais.total_empresas_bazar = total
         pais.total_empresas_mercado = total
         pais.save
     end
     
   end 
   
   puts "#{DateTime.now} Países: Actualizada información local de los países"
   
   
   hydra = Typhoeus::Hydra.new
   
   puts "#{DateTime.now} Bazares: Empiezo a recolectar información de los bazares"
   
   micluster = Conf.find_by_nombre("BazarId").valor

   for cluster in Cluster.all
    
     if ( cluster.id != micluster.to_i && cluster.id != 1 )

       # actualizamos la información de los perfiles de otros bazares

       puts "#{DateTime.now} Perfiles: Obteniendo la información de:  #{cluster.nombre} -> #{cluster.url}."

       uri = "#{cluster.url}/api/perfiles.json"
       puts "URI #{uri}"
       r = Typhoeus::Request.new(uri, :timeout => 20000)
       r.on_complete do |response|
         case response.curl_return_code
         when 0

           begin 
             perfiles = JSON.parse(response.body)
           rescue 
             puts "ERROR: No se ha podido procesar los datos de #{uri}"
           else
             perfiles.each{ |key|
               
               perfil = Bazarcms::Perfil.find_by_codigo(key['id'])

               perfil.total_empresas_mercado += key['total_empresas_bazar'].to_i
               perfil.save
           
             }
             puts "#{DateTime.now} Perfil: Actualizada la información de:  #{cluster.nombre} -> #{cluster.url}."
          end
         else
           puts "ERROR en la petición ---------->"+response.inspect
         end

       end

       hydra.queue r        
    

       # actualizamos la información de los países de otros bazares

       puts "#{DateTime.now} Países: Obteniendo la información de: #{cluster.nombre} -> #{cluster.url}."

       uri = "#{cluster.url}/api/paises.json"
       puts "URI #{uri}"
       r = Typhoeus::Request.new(uri, :timeout => 20000)
       r.on_complete do |response|
         case response.curl_return_code
         when 0

           begin
             paises = JSON.parse(response.body)
           rescue 
             puts "ERROR: no se han podido procesar los datos de #{uri}"
           else 
             paises.each{ |key|
               
               pais = Pais.find_by_id(key['id'])

               pais.total_empresas_mercado += key['total_empresas_bazar'].to_i
               pais.save
           
             }
           
              puts "#{DateTime.now} Países: Actualizada la información: #{cluster.nombre} -> #{cluster.url}."
            end
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
