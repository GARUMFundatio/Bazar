module FavoritosHelper
  
  def helper_favo(bazar, empresa)
    fav = Favorito.find_by_bazar_id_and_empresa_id_and_user_id (bazar, empresa, current_user.id)
    if (!fav.nil?)
      "<div id='favo#{bazar}-#{empresa}' class='favoritos'><a href='#' onclick='$(\"\#favo#{bazar}-#{empresa}\").load(\"/favorito/delfav?bazar=#{bazar}&empresa=#{empresa}\")'><img src='images/favorito.png'></a></div>".html_safe
    else 
      "<div id='favo#{bazar}-#{empresa}' class='favoritos'><a href='#' onclick='$(\"\#favo#{bazar}-#{empresa}\").load(\"/favorito/addfav?bazar=#{bazar}&empresa=#{empresa}\")'><img src='images/addfav.gif'></a></div>".html_safe
    end
  end 
end
