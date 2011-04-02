# tareas que se ejecutan diariamente

namespace :bazar do

 desc "Actualización de la información de la red"

 task :actualiza => :environment do |t|
   
   for cluster in Cluster::all
     puts "cluster: #{cluster.nombre} - #{cluster.url}"

     # recojemos la información básica del bazar 
     
     uri = URI.parse("#{cluster.url}/api/info.json")

     post_body = []
     post_body << "Content-Type: text/plain\r\n"
  
     http = Net::HTTP.new(uri.host, uri.port)
     http.open_timeout = http.read_timeout = 10
       
     request = Net::HTTP::Get.new(uri.request_uri)
     request.body = post_body.join
     request["Content-Type"] = "text/plain"
     datos = ""
     begin 
         
       res =  Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request) }
       case res
       when Net::HTTPSuccess, Net::HTTPRedirection
         datos = JSON.parse(res.body)

         puts "#{datos.inspect} <-----------"
         
         # actualizamos la información del cluster 
         
         cluster.empresas = datos['empresas']
         cluster.save
         
      else
         puts "ERROR en la petición a #{uri}---------->"+res.error!
       end       
       rescue Exception => e
         puts "Exception leyendo #{cluster.url} Got #{e.class}: #{e}"        
     end
     
     # actualizamos las estadísticas de este bazar
     puts "actualizamos las estadisticas"

     bazar = Estadisticasbazar.find_by_bazar_id_and_fecha(cluster.id, DateTime.now.strftime("%Y-%m-%d"))
     puts "bazar #{bazar.inspect}"
     if (bazar.nil?)
       puts "No existe lo creo"
       bazar = Estadisticasbazar.new
       bazar.fecha = DateTime.now.strftime("%Y-%m-%d")
       bazar.bazar_id = cluster.id
     end 
     
     bazar.empresas = datos['empresas']
     bazar.consultas = datos['consultas']
     bazar.clustersactivos = datos['clustersactivos']
     
     bazar.save

     # por cada uno de los bazares obtenemos la lista de empresas. 

     uri = URI.parse("#{cluster.url}/api/empresas.json")

     post_body = []
     post_body << "Content-Type: text/plain\r\n"
  
     http = Net::HTTP.new(uri.host, uri.port)
     http.open_timeout = http.read_timeout = 20
       
     request = Net::HTTP::Get.new(uri.request_uri)
     request.body = post_body.join
     request["Content-Type"] = "text/plain"
     datos = ""
     begin 
         
       res =  Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request) }
       case res
       when Net::HTTPSuccess, Net::HTTPRedirection
         datos = JSON.parse(res.body)

         puts "#{datos.inspect} <----------- datos empresas"
         
         for dat in datos 
            empresa = Estadisticasempresa.find_by_bazar_id_and_empresa_id(cluster.id, dat['id'])
            puts "empresa #{empresa.inspect}"
            if (empresa.nil?)
              puts "No existe lo creo"
              empresa = Estadisticasempresa.new
              empresa.empresa_id = dat['id']
              empresa.bazar_id = cluster.id
            end 

            empresa.fundada = dat['fundada']
            empresa.consultas = dat['consultas']
            empresa.nombre = dat['nombre']
            empresa.url = dat['url']

            empresa.save
            
         end 
             
      else
         puts "ERROR en la petición a #{uri}---------->"+res.error!
       end       
      rescue Exception => e
         puts "Exception leyendo #{cluster.url} Got #{e.class}: #{e}"        
     end       
       
   end 

 # fin tarea actualizar
 end


end
