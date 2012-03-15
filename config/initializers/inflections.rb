
puts "bazar:: borro los inflectors"
ActiveSupport::Inflector.inflections.clear

# Agregamos las reglas de inflección
ActiveSupport::Inflector.inflections do |inflect|

puts "bazar:: nuevos inflectors"

inflect.plural /([aeiou])([A-Z]|_|$)/, '\1s\2'
inflect.plural /([rlnd])([A-Z]|_|$)/, '\1es\2'
inflect.plural /([aeiou])([A-Z]|_|$)([a-z]+)([rlnd])($)/, '\1s\2\3\4es\5'
inflect.plural /([rlnd])([A-Z]|_|$)([a-z]+)([aeiou])($)/, '\1es\2\3\4s\5'
inflect.singular /([aeiou])s([A-Z]|_|$)/, '\1\2'
inflect.singular /([rlnd])es([A-Z]|_|$)/, '\1\2'
inflect.singular /([aeiou])s([A-Z]|_)([a-z]+)([rlnd])es($)/, '\1\2\3\4\5'
inflect.singular /([rlnd])es([A-Z]|_)([a-z]+)([aeiou])s($)/, '\1\2\3\4\5'

inflect.irregular 'user', 'users'
inflect.irregular 'rol', 'roles'
inflect.irregular 'account', 'accounts'
inflect.irregular 'password', 'passwords'
inflect.irregular 'password_reset', 'password_resets'
inflect.irregular 'conf', 'confs'
inflect.irregular 'session', 'sessions'
inflect.irregular 'tagging', 'taggings'
inflect.irregular 'tag', 'tags'
inflect.irregular 'interes', 'intereses'
inflect.irregular 'ciudad', 'ciudades'
inflect.irregular 'pais', 'paises'
inflect.irregular 'cluster', 'clusters'
inflect.irregular 'noticia', 'noticias'
inflect.irregular 'actividad', 'actividades'
inflect.irregular 'favorito', 'favoritos'
inflect.irregular 'estadisticasconsulta', 'estadisticasconsultas'
inflect.irregular 'slug', 'slugs'
inflect.irregular 'pais', 'paises'


end
