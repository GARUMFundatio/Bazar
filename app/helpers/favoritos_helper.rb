module FavoritosHelper
  
  def helper_favo(bazar, empresa, nombre, pre)

    fav = Favorito.find_by_bazar_id_and_empresa_id_and_user_id(bazar, empresa, current_user.id)
    if (!fav.nil?)
      "<div class='favoritos favo#{bazar}-#{empresa}'><a href='#' title='Quitar de Favoritos' onclick='$(\".favo#{bazar}-#{empresa}\").load(\"/favorito/delfav?bazar=#{bazar}&empresa=#{empresa}&pre=#{pre}\")'><img src='/images/favorito.png'></a></div>".html_safe
    else 
      "<div class='favoritos favo#{bazar}-#{empresa}'><a href='#' title='Agregar a Favoritos' onclick='$(\".favo#{bazar}-#{empresa}\").load(\"/favorito/addfav?bazar=#{bazar}&empresa=#{empresa}&nombre_empresa=#{nombre.gsub(' ','_')}&pre=#{pre}\")'><img src='/images/addfav.png'></a></div>".html_safe
    end

  end 
  
  def helper_favo2(bazar, empresa, nombre, pre, user)

    "<div class='favoritos favo#{bazar}-#{empresa}' ><a href='#' title='Agregar a Favoritos' onclick='$(\".favo#{bazar}-#{empresa}\").load(\"/favorito/addfav?bazar=#{bazar}&empresa=#{empresa}&nombre_empresa=#{nombre.gsub(' ','_')}&pre=#{pre}\")'><img src='/images/addfav.png'></a></div>".html_safe

  end 
  
  def helper_favoofe(bazar, empresa, nombre, pre)

    fav = Bazarcms::Ofertasfavorito.find_by_bazar_id_and_empresa_id_and_user_id(bazar, empresa, current_user.id)
    if (!fav.nil?)
      "<div class='favoritos favoo#{bazar}-#{empresa}'><a href='#' title='Quitar de Favoritos' onclick='$(\".favoo#{bazar}-#{empresa}\").load(\"/ofertasfavorito/delfav?bazar=#{bazar}&empresa=#{empresa}&pre=#{pre}\")'><img src='/images/favorito.png'></a></div>".html_safe
    else 
      "<div class='favoritos favoo#{bazar}-#{empresa}'><a href='#' title='Agregar a Favoritos' onclick='$(\".favoo#{bazar}-#{empresa}\").load(\"/ofertasfavorito/addfav?bazar=#{bazar}&empresa=#{empresa}&nombre_empresa=#{nombre.gsub(' ','_')}&pre=#{pre}\")'><img src='/images/addfav.png'></a></div>".html_safe
    end

  end 
  
  def helper_favoofe2(bazar, empresa, nombre, pre, user)

    "<div class='favoritos favoo#{bazar}-#{empresa}' ><a href='#' title='Agregar a Favoritos' onclick='$(\".favoo#{bazar}-#{empresa}\").load(\"/ofertasfavorito/addfav?bazar=#{bazar}&empresa=#{empresa}&nombre_empresa=#{nombre.gsub(' ','_')}&pre=#{pre}\")'><img src='/images/addfav.png'></a></div>".html_safe

  end 
  
  
end
