# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = Cluster.find(Conf.find_by_nombre("BazarId").valor).url
SitemapGenerator::Sitemap.yahoo_app_id = nil 
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.add_links do |sitemap|

  Cluster.find_each do |cluster|
    sitemap.add "/cluster/#{cluster.slug.name}", :priority => 0.7, :changefreq => 'daily',:lastmod => cluster.updated_at
  end

  Bazarcms::Oferta.find_each do |oferta|
    sitemap.add "/bazarcsm/ofertas/#{oferta.id}", :priority => 0.7, :changefreq => 'daily',:lastmod => oferta.fecha
  end

  Bazarcms::Empresa.find_each do |empresa|
    sitemap.add "/bazarcsm/empresas/#{empresa.id}", :priority => 0.7, :changefreq => 'daily',:lastmod => empresa.updated_at
  end
  
end