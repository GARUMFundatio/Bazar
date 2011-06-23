module FavoritosHelper
  
  def helper_favo(bazar, empresa, nombre, pre)
    fav = Favorito.find_by_bazar_id_and_empresa_id_and_user_id(bazar, empresa, current_user.id)
    if (!fav.nil?)
      "<div id='#{pre}-favo#{bazar}-#{empresa}' class='favoritos'><a href='#' title='Quitar de Favoritos' onclick='$(\"\##{pre}-favo#{bazar}-#{empresa}\").load(\"/favorito/delfav?bazar=#{bazar}&empresa=#{empresa}&pre=#{pre}\")'><img src='/images/favorito.png'></a></div>".html_safe
    else 
      "<div id='#{pre}-favo#{bazar}-#{empresa}' class='favoritos'><a href='#' title='Agregar a Favoritos' onclick='$(\"\##{pre}-favo#{bazar}-#{empresa}\").load(\"/favorito/addfav?bazar=#{bazar}&empresa=#{empresa}&nombre_empresa=#{nombre.gsub(' ','_')}&pre=#{pre}\")'><img src='/images/addfav.png'></a></div>".html_safe
    end
  end 
  
  def helper_favo2(bazar, empresa, nombre, pre, user)
    fav = Favorito.find_by_bazar_id_and_empresa_id_and_user_id(bazar, empresa, user)
    if (!fav.nil?)
      "<div id='#{pre}-favo#{bazar}-#{empresa}' class='favoritos'><a href='#' title='Quitar de Favoritos' onclick='$(\"\##{pre}-favo#{bazar}-#{empresa}\").load(\"/favorito/delfav?bazar=#{bazar}&empresa=#{empresa}&pre=#{pre}\")'><img src='/images/favorito.png'></a></div>".html_safe
    else 
      "<div id='#{pre}-favo#{bazar}-#{empresa}' class='favoritos'><a href='#' title='Agregar a Favoritos' onclick='$(\"\##{pre}-favo#{bazar}-#{empresa}\").load(\"/favorito/addfav?bazar=#{bazar}&empresa=#{empresa}&nombre_empresa=#{nombre.gsub(' ','_')}&pre=#{pre}\")'><img src='/images/addfav.png'></a></div>".html_safe
    end
  end 
  
end
