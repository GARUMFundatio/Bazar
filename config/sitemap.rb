# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = Cluster.find(Conf.find_by_nombre("BazarId").valor).url
SitemapGenerator::Sitemap.yahoo_app_id = nil 
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

sitemap.add '/home/datos', :priority => 0.7, :changefreq => 'daily'
sitemap.add '/home/bazares', :priority => 0.5, :changefreq => 'weekly'
sitemap.add '/ciudades', :priority => 0.5, :changefreq => 'weekly'
sitemap.add '/paises', :priority => 0.5, :changefreq => 'weekly'
sitemap.add '/api/index', :priority => 0.5, :changefreq => 'weekly'
sitemap.add '/api/ejemploinfo', :priority => 0.5, :changefreq => 'weekly'
sitemap.add '/api/ejemploempresas', :priority => 0.5, :changefreq => 'weekly'
sitemap.add '/api/ejemploinfoempresa', :priority => 0.5, :changefreq => 'weekly'
sitemap.add '/api/ejemploperfiles', :priority => 0.5, :changefreq => 'weekly'
sitemap.add '/api/ejemplopaises', :priority => 0.5, :changefreq => 'weekly'
sitemap.add '/actividades.rss', :priority => 0.7, :changefreq => 'daily'
sitemap.add '/ofertas.rss', :priority => 0.7, :changefreq => 'daily'
sitemap.add '/ofertas2.rss', :priority => 0.7, :changefreq => 'daily'

SitemapGenerator::Sitemap.add_links do |sitemap|

  Cluster.where ('id <> 1') do |cluster|
    sitemap.add "/clusters/#{cluster.friendly_id}", :priority => 0.4, :changefreq => 'daily',:lastmod => cluster.updated_at
  end

  bazar = Conf.find_by_nombre('BazarId').valor.to_i
  
  Bazarcms::Oferta.find_each do |oferta|
    sitemap.add "/bazarcms/ofertas/#{oferta.friendly_id}?bazar_id=#{oferta.bazar_id}", :priority => 0.9, :changefreq => 'daily',:lastmod => oferta.fecha
  end

  Bazarcms::Empresa.find_each do |empresa|
    # puts empresa.inspect
    if !empresa.slug.nil?
      sitemap.add "/bazarcms/empresas/show2/#{empresa.friendly_id}", :priority => 0.7, :changefreq => 'daily',:lastmod => empresa.updated_at
    else 
      sitemap.add "/bazarcms/empresas/show2/#{empresa.id}", :priority => 0.7, :changefreq => 'daily',:lastmod => empresa.updated_at      
    end 
    
  end
  
  Bazarcms::Ubicacion.find_each do |ubi|
    if (!ubi.ciudad.nil?) 
      ciudad = Ciudad.find(ubi.ciudad_id)
      sitemap.add "/ciudades/#{ciudad.friendly_id}", :priority => 0.5, :changefreq => 'weekly'
    end
  end  

  Bazarcms::Empresa.where('rating > 0').each do |empresa|
    sitemap.add "/bazarcms/ficharating/#{empresa.id}?bazar_id=#{bazar}", :priority => 0.8, :changefreq => 'daily'
  end  
  
  
  Pais.where('total_empresas_bazar > 0').each do |pais|
    sitemap.add "/paises/#{pais.friendly_id}", :priority => 0.5, :changefreq => 'weekly'
  end  

  Bazarcms::Perfil.where('total_empresas_bazar > 0').each do |perfil|
    sitemap.add "/bazarcms/perfiles/#{perfil.friendly_id}", :priority => 0.5, :changefreq => 'weekly'
  end  

  
end
