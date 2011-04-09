# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110409164509) do

  create_table "actividades", :force => true do |t|
    t.integer  "bazar_id"
    t.integer  "user_id"
    t.integer  "local_id"
    t.datetime "fecha"
    t.text     "desc"
    t.string   "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nombre_empresa"
  end

  add_index "actividades", ["fecha"], :name => "index_actividad_fecha"

  create_table "ciudades", :force => true do |t|
    t.string   "descripcion",                         :default => "", :null => false
    t.integer  "pais_id",                                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitud"
    t.float    "longitud"
    t.string   "geocode"
    t.string   "pais_codigo",            :limit => 2
    t.integer  "total_empresas_bazar"
    t.integer  "total_empresas_mercado"
  end

  create_table "clusters", :force => true do |t|
    t.string   "nombre"
    t.string   "desc"
    t.string   "activo"
    t.string   "url"
    t.string   "miclave"
    t.string   "suclave"
    t.integer  "empresas"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "confs", :force => true do |t|
    t.string   "nombre"
    t.integer  "grupo_id"
    t.string   "tipo"
    t.string   "valor"
    t.string   "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["locked_by"], :name => "delayed_jobs_locked_by"
  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "empresas", :force => true do |t|
    t.integer  "user_id"
    t.string   "nombre"
    t.text     "desc"
    t.integer  "fundada"
    t.integer  "moneda"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

  add_index "empresas", ["user_id"], :name => "index_empresas_on_user_id"

  create_table "empresasconsultas", :force => true do |t|
    t.integer  "empresa_id"
    t.string   "desc"
    t.integer  "total_consultas"
    t.integer  "total_respuestas"
    t.integer  "total_resultados"
    t.datetime "fecha_inicio"
    t.datetime "fecha_fin"
    t.text     "sql"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "empresasconsultas", ["empresa_id", "fecha_inicio"], :name => "index_empresasconsultas_on_empresa_id_and_fecha_inicio"

  create_table "empresasdatos", :force => true do |t|
    t.integer  "empresa_id"
    t.integer  "periodo"
    t.integer  "empleados"
    t.integer  "ventas"
    t.integer  "compras"
    t.integer  "resultados"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "empresasdatos", ["empresa_id", "periodo"], :name => "index_empresasdatos_on_empresa_id_and_periodo"

  create_table "empresasperfiles", :force => true do |t|
    t.string "empresa_id"
    t.string "codigo"
    t.string "tipo"
  end

  add_index "empresasperfiles", ["empresa_id", "codigo"], :name => "index_empresasperfiles_on_empresa_id_and_codigo"

  create_table "empresasresultados", :force => true do |t|
    t.integer  "empresasconsulta_id"
    t.integer  "cluster_id"
    t.integer  "empresa_id"
    t.string   "orden"
    t.string   "enlace"
    t.string   "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "empresasresultados", ["empresasconsulta_id", "orden"], :name => "index_empresasresultados_on_empresasconsulta_id_and_orden"

  create_table "estadisticasconsultas", :force => true do |t|
    t.datetime "fecha"
    t.integer  "bazar_id"
    t.integer  "empresa_id"
    t.integer  "empresas"
    t.string   "consulta"
    t.string   "tipo"
  end

  create_table "favoritos", :force => true do |t|
    t.integer  "bazar_id"
    t.integer  "user_id"
    t.integer  "empresa_id"
    t.datetime "fecha"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nombre_empresa"
  end

  create_table "gruposconfs", :force => true do |t|
    t.string   "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mensajes", :force => true do |t|
    t.datetime "fecha"
    t.string   "tipo"
    t.datetime "borrado"
    t.datetime "leido"
    t.integer  "de"
    t.integer  "para"
    t.text     "texto"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "asunto"
    t.integer  "bazar_origen"
    t.integer  "bazar_destino"
    t.string   "de_email"
    t.string   "de_nombre"
    t.string   "para_email"
    t.string   "para_nombre"
  end

  add_index "mensajes", ["de", "fecha"], :name => "index_mensaje_de"
  add_index "mensajes", ["para", "fecha"], :name => "index_mensaje_para"

  create_table "noticias", :force => true do |t|
    t.text     "titulo"
    t.text     "texto"
    t.datetime "fecha"
    t.integer  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "noticias", ["fecha"], :name => "index_noticia_fecha"

  create_table "ofertas", :force => true do |t|
    t.integer  "bazar_id"
    t.integer  "empresa_id"
    t.string   "tipo"
    t.datetime "fecha"
    t.datetime "fecha_hasta"
    t.string   "titulo"
    t.text     "texto"
    t.text     "texto_correo"
    t.integer  "vistas"
    t.integer  "clicks"
    t.integer  "contactos"
    t.integer  "fav_empresa"
    t.integer  "fav_oferta"
    t.integer  "total_empresas"
    t.string   "filtro"
    t.string   "publica"
    t.integer  "cid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ofertas", ["empresa_id"], :name => "index_ofertas_on_empresa_id"
  add_index "ofertas", ["fecha"], :name => "index_ofertas_on_fecha"
  add_index "ofertas", ["fecha_hasta"], :name => "index_ofertas_on_fecha_hasta"

  create_table "ofertasconsultas", :force => true do |t|
    t.integer  "empresa_id"
    t.string   "desc"
    t.integer  "total_consultas"
    t.integer  "total_respuestas"
    t.integer  "total_resultados"
    t.datetime "fecha_inicio"
    t.datetime "fecha_fin"
    t.text     "sql"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ofertasconsultas", ["empresa_id", "fecha_inicio"], :name => "index_ofertasconsultas_on_empresa_id_and_fecha_inicio"

  create_table "ofertasfavoritos", :force => true do |t|
    t.integer  "bazar_id"
    t.integer  "user_id"
    t.integer  "empresa_id"
    t.datetime "fecha"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nombre_empresa"
    t.string   "titulo_oferta"
  end

  add_index "ofertasfavoritos", ["user_id", "fecha"], :name => "index_ofertasfavoritos_on_user_id_and_fecha"

  create_table "ofertaspaises", :force => true do |t|
    t.integer "consulta_id"
    t.string  "codigo"
    t.string  "desc"
  end

  add_index "ofertaspaises", ["consulta_id", "codigo"], :name => "index_ofertaspaises_on_consulta_id_and_codigo"

  create_table "ofertasperfiles", :force => true do |t|
    t.integer "consulta_id"
    t.string  "codigo"
    t.string  "tipo"
  end

  add_index "ofertasperfiles", ["consulta_id", "codigo"], :name => "index_ofertasperfiles_on_consulta_id_and_codigo"

  create_table "ofertasresultados", :force => true do |t|
    t.integer  "ofertasconsulta_id"
    t.integer  "cluster_id"
    t.integer  "empresa_id"
    t.string   "orden"
    t.string   "enlace"
    t.string   "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ofertasresultados", ["ofertasconsulta_id", "orden"], :name => "index_ofertasresultados_on_ofertasconsulta_id_and_orden"

  create_table "paises", :force => true do |t|
    t.string   "descripcion",            :limit => 100, :null => false
    t.string   "codigo",                 :limit => 2,   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "capital"
    t.integer  "total_empresas_bazar"
    t.integer  "total_empresas_mercado"
  end

  create_table "perfiles", :force => true do |t|
    t.string  "codigo"
    t.string  "desc"
    t.integer "nivel"
    t.text    "ayuda"
    t.integer "total_empresas_bazar"
    t.integer "total_empresas_mercado"
  end

  add_index "perfiles", ["codigo"], :name => "index_perfiles_on_codigo"

  create_table "perfiles_copy", :force => true do |t|
    t.string  "codigo"
    t.string  "desc"
    t.integer "nivel"
    t.text    "ayuda"
  end

  add_index "perfiles_copy", ["codigo"], :name => "index_perfiles_on_codigo"

  create_table "roles", :force => true do |t|
    t.string   "rol"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "rol_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "ubicaciones", :force => true do |t|
    t.integer  "empresa_id"
    t.string   "ciudad_id"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ubicaciones", ["ciudad_id"], :name => "index_ubicaciones_on_ciudad_id"
  add_index "ubicaciones", ["empresa_id"], :name => "index_ubicaciones_on_empresa_id"

  create_table "users", :force => true do |t|
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true

  create_table "usuarios", :force => true do |t|
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "usuarios", ["email"], :name => "index_users_on_email", :unique => true
  add_index "usuarios", ["login"], :name => "index_users_on_login", :unique => true
  add_index "usuarios", ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true

end
