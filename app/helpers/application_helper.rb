module ApplicationHelper
  
  def pageless(total_pages, url=nil, container=nil)
    opts = {
      :totalPages => total_pages,
      :url        => url,
      :loaderMsg  => 'Cargando más info'
    }
    
    container && opts[:container] ||= container
    
    javascript_tag("$('#results').pageless(#{opts.to_json});")
  end

  # Devuelve la descripción para el tipo de oferta
  
  def oferta_tipo (tipo)

    if tipo == 'O'
        return "Oferta"
    else 
        return "Demanda"
    end
      
  end  

  # Convierte de parametros de busqueda (campo sql a texto)

  def sql2texto (sql)

    text = "<span>"

    for para in sql.split('&')

      cam = para.split('=')

      # text += "traza  #{cam[0]} => #{cam[1]}<br/>"
      
      # traducimos las palabras clave 
      
      if (cam[0] == "q")
        text += "<b>Palabras clave:</b> "
        
        if (cam[1] == '*')
          text += "Cualquier valor</br>"
        else
          
          text += "Que tengan las palabras clave: "
          for val in cam[1].split('+')
            text += "#{val} "
          end 
          
          text += "<br/>"
        end 

      end
      
      # traducimos los sectores 

      if (cam[0] == "pofertan")
        text += "<b>Ofertan en los siguientes sectores:</b> "

        if (cam[1].nil?)
          text += "Todos los sectores</br>"
        else
          text += "<br/>"
          for val in cam[1].split(',')
            # text += "traza  #{cam[0]} => #{cam[1]}<br/>"
            
            per = Bazarcms::Perfil.find_by_codigo(val) 
            if !per.nil?
              text += "#{per.codigo}: #{per.desc} <br/>"
            end 
          end 

          text += ""
        end 

      end

      # traducimos los sectores 

      if (cam[0] == "pdemandan")
        text += "<b>Demandan en los siguientes sectores:</b> "

        if (cam[1].nil?)
          text += "Todos los sectores</br>"
        else
          text += "<br/>"
          for val in cam[1].split(',')
            # text += "traza  #{cam[0]} => #{cam[1]}<br/>"
            
            per = Bazarcms::Perfil.find_by_codigo(val) 
            if !per.nil?
              text += "#{per.codigo}: #{per.desc} <br/>"
            end 
          end 

          text += "<br/>"
        end 

      end

      # traducimos los países

      if (cam[0] == "ppaises")
        text += "<b>De estos países:</b> "

        if (cam[1].nil?)
          text += "Todos los países</br>"
        else
          text += "<br/>"
          for val in cam[1].split(',')
            # text += "traza  #{cam[0]} => #{cam[1]}<br/>"
            
            pais = Pais.find_by_id(val) 
            if !pais.nil?
              text += "#{pais.codigo}: #{pais.descripcion} <br/>"
            end 
          end 

          text += "<br/>"
        end 

      end


    end 
    
    text += "</span>"  
    return text   
  end  

    
end
