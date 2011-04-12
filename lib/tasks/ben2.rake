# tareas que se ejecutan diariamente

require "typhoeus"
  
namespace :bazar do

 desc "Actualización de la información de la red"

 task :ben2 => :environment do |t|

   esta = []
   
   puts "#{DateTime.now}: Actualización de la información."
   
   # Actualizamos la lista de clusters

   puts "#{DateTime.now}: Bazares: Actualizamos la información de bazares."
   uri = "http://directorio.garumfundatio.org/clusters.json"

   for veces in 1..3
     
   for simu in [5,10,50]
     
       puts "----> #{simu} peticiones simultaneas"

       tt = Time.now
       
       for ii in 0...simu

         hydra = Typhoeus::Hydra.new

        uri = "http://bazar.garumfundatio.org/bazarcms/buscaempresas?q=%2A&qe=0+10&qv=0+10&qc=0+10&qr=0+10&pofertan=#{ii}&pdemandan=#{ii}&ppaises=#{ii}&bid=864&cid=3"
        r = Typhoeus::Request.new(uri, :timeout => 30000)
        r.on_complete do |response|
          case response.curl_return_code
          when 0
            esta << [simu, response.time]
          else
            puts "ERROR en la petición ---------->"+response.inspect
          end
    
        end
        hydra.queue r
        hydra.run
        sleep(0.100)
      end 
    
        
        puts "#{Time.now-tt} segs"
        tiempo = Time.now.to_f - tt.to_f
        puts "#{ii} ---> tiempo "
        case simu
          when 5
            tot5seg = tiempo
            puts "#{tot5seg}"
                
          when 10
            tot10seg = tiempo
            puts "#{tot10seg}"
            
          when 50
            tot50seg = tiempo
            puts "#{tot50seg}"
        end 
        puts "Fin ----> #{simu} peticiones simultaneas"
    end 
  end
  
puts "totales: #{esta.inspect}"  

tot5min = 9999
tot5max = tot5avg = tot5tot = tot5sum = tot5por = 0 
tot10min = 9999
tot10max = tot10avg = tot10tot = tot10sum = tot10por = 0 
tot50min = 9999
tot50max = tot50avg = tot50tot = tot50sum = tot50por = 0 

for est in esta 
  case est[0]
  when 5
    tot5tot += 1
    tot5min = est[1] if (est[1] < tot5min)
    tot5max = est[1] if (est[1] > tot5max)
    tot5sum += est[1]
  when 10
    tot10tot += 1
    tot10min = est[1] if (est[1] < tot10min)
    tot10max = est[1] if (est[1] > tot10min)
    tot10sum += est[1]
  when 50
    tot50tot += 1
    tot50min = est[1] if (est[1] < tot50min)
    tot50max = est[1] if (est[1] > tot50min)
    tot50sum += est[1]
  end 
  
end 

  tot5avg = tot5sum/tot5tot
  tot10avg = tot10sum/tot10tot
  tot50avg = tot50sum/tot50tot
  puts "#{tot5tot} - #{tot5seg}"
  puts "#{tot10tot} - #{tot10seg}"
  puts "#{tot50tot} - #{tot50seg}"

  tot5por = 5/tot5seg 
  tot10por = 10/tot10seg 
  tot50por = 50/tot50seg 
  
  str="5\t#{tot5min}\t#{tot5avg}\t#{tot5max}\t#{tot5seg}\t#{tot5por}\n10\t#{tot10min}\t#{tot10avg}\t#{tot10max}\t#{tot10seg}\t#{tot10por}\n50\t#{tot50min}\t#{tot50avg}\t#{tot50max}\t#{tot50seg}\t#{tot50por}"
  str = str.gsub('.',',')
  puts str
 # fin tarea actualizar
 end


end
