xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title BZ_param("Titular")+": Actividad del Bazar"
    xml.description BZ_param("Subtitular")
    xml.link Cluster.find(BZ_param("BazarId")).url

    for actividad in @actividades
      xml.item do
        xml.title "#{Bazarcms::Empresa.find(actividad.bazar_id).nombre}:"
        xml.description actividad.desc+'\n\n'+"Más Información de esta empresa:\n\n<a href='"+Bazarcms::Empresa.find(actividad.bazar_id).friendly_id+"'>"+Bazarcms::Empresa.find(actividad.bazar_id).nombre+'</a>'
        xml.pubDate actividad.fecha.to_s(:rfc822)
        xml.link Cluster.find(BZ_param("BazarId")).url+"/actividades/#{actividad.id}"
        xml.guid Cluster.find(BZ_param("BazarId")).url+"/actividades/#{actividad.id}"
      end
    end
  end
end