# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_20_162042) do

  create_table "clientes", force: :cascade do |t|
    t.string "nombre"
    t.string "contacto"
    t.string "tel"
    t.string "direccion"
    t.string "entidad"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "incident_types", force: :cascade do |t|
    t.string "tipo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "incidents", force: :cascade do |t|
    t.integer "inspection_id", null: false
    t.integer "incident_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "cantidad"
    t.index ["incident_type_id"], name: "index_incidents_on_incident_type_id"
    t.index ["inspection_id"], name: "index_incidents_on_inspection_id"
  end

  create_table "inspections", force: :cascade do |t|
    t.integer "num_item"
    t.string "lote"
    t.string "lote_prod1"
    t.string "lote_prod2"
    t.integer "inspecciones"
    t.integer "ok"
    t.integer "ng"
    t.integer "recuperadas"
    t.integer "scrap"
    t.integer "incidentes"
    t.integer "report_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_inspections_on_report_id"
  end

  create_table "parts", force: :cascade do |t|
    t.string "num_parte"
    t.string "nombre"
    t.integer "plant_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plant_id"], name: "index_parts_on_plant_id"
  end

  create_table "plants", force: :cascade do |t|
    t.string "nombre"
    t.string "contacto"
    t.string "tel"
    t.string "direccion"
    t.string "entidad"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "quotations", force: :cascade do |t|
    t.integer "cliente_id", null: false
    t.integer "request_id", null: false
    t.string "orden_compra"
    t.date "fecha_orden"
    t.date "fecha_cotizada"
    t.string "modo_cobro"
    t.decimal "precio"
    t.decimal "sub_total"
    t.decimal "iva"
    t.decimal "total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "inventario"
    t.index ["cliente_id"], name: "index_quotations_on_cliente_id"
    t.index ["request_id"], name: "index_quotations_on_request_id"
  end

  create_table "reports", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "turno"
    t.datetime "fecha_inicio"
    t.datetime "fecha_termino"
    t.integer "total_inspeccion"
    t.integer "total_ok"
    t.integer "total_ng"
    t.integer "total_recupera"
    t.integer "total_basura"
    t.integer "total_incidentes"
    t.integer "quotation_id", null: false
    t.boolean "capturando"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status"
    t.index ["quotation_id"], name: "index_reports_on_quotation_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "cliente_id", null: false
    t.integer "part_id", null: false
    t.string "serie"
    t.string "lote"
    t.integer "inventario"
    t.integer "incident_type_id", null: false
    t.string "ayuda_visual"
    t.string "metodo"
    t.string "consumo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cliente_id"], name: "index_requests_on_cliente_id"
    t.index ["incident_type_id"], name: "index_requests_on_incident_type_id"
    t.index ["part_id"], name: "index_requests_on_part_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nombre"
    t.string "p_apellido"
    t.string "s_apellido"
    t.string "tel"
    t.string "email"
    t.integer "permiso"
    t.string "usuario"
    t.string "clave"
    t.boolean "conectado"
    t.date "ultima_fecha"
    t.time "ultima_hora"
    t.integer "duracion"
    t.date "conexion_fecha"
    t.time "conexion_hora"
    t.integer "cliente_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cliente_id"], name: "index_users_on_cliente_id"
  end

  add_foreign_key "incidents", "incident_types"
  add_foreign_key "incidents", "inspections"
  add_foreign_key "inspections", "reports"
  add_foreign_key "parts", "plants"
  add_foreign_key "quotations", "clientes"
  add_foreign_key "quotations", "requests"
  add_foreign_key "reports", "quotations"
  add_foreign_key "reports", "users"
  add_foreign_key "requests", "clientes"
  add_foreign_key "requests", "incident_types"
  add_foreign_key "requests", "parts"
  add_foreign_key "users", "clientes"
end
