xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title BZ_param("Titular")+": Noticias"
    xml.description BZ_param("Subtitular")
    xml.link Cluster.find(BZ_param("BazarId")).url

    for noticia in @noticias
      xml.item do
        xml.title noticia.titulo
        xml.description noticia.texto
        xml.pubDate noticia.fecha.to_s(:rfc822)
        xml.link Cluster.find(BZ_param("BazarId")).url
        xml.guid Cluster.find(BZ_param("BazarId")).url
      end
    end
  end
end