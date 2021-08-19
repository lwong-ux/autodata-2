# This file should contain all the record creation needed to seed the database with its #default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside 
#the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


entidades =  ["Aguascalientes", "Baja California", "Baja California Sur", 
  "Campeche", "Chiapas", "Chihuahua", "Ciudad de México", "Coahuila", "Colima", 
  "Durango", "Edo. de México", "Guanajuato", "Guerrero",  "Hidalgo", "Jalisco", "Michoacán", 
  "Morelos", "Nayarit", "Nuevo León", "Oaxaca", "Puebla", "Querétaro", "Quintana Roo",
  "San Luis Potosí", "Sinaloa", "Sonora", "Tabasco", "Tamaulipas", "Tlaxcala", 
  "Veracruz", "Yucatán", "Zacatecas"]

# Siembra la atabla de cientes
200.times do |n|
  nombre = Faker::Company.name
  contacto = Faker::Name.name_with_middle
  tel = Faker::PhoneNumber.cell_phone
  direccion = Faker::Address.street_address
  entidad = entidades[rand(0..31)]
  Cliente.create!(nombre: nombre, contacto: contacto, 
    tel: tel, direccion: direccion, entidad: entidad)
end

# Siembra la tabla de plantas
30.times do |n|
  nombre = Faker::IndustrySegments.industry + "-PTA-" + (n+1).to_s
  contacto = Faker::Name.name_with_middle
  tel = Faker::PhoneNumber.phone_number
  direccion = Faker::Address.street_address
  entidad = entidades[rand(0..31)]
  Plant.create!(nombre: nombre, contacto: contacto, 
    tel: tel, direccion: direccion, entidad: entidad)
end

# Siembra la tabla de partes
200.times do |n|
  num_parte = Faker::Barcode.ean_with_composite_symbology(8)
  nombre = Faker::ElectricalComponents.electromechanical
  plant_id = rand(1..9)
  Part.create!(num_parte: num_parte, nombre: nombre, plant_id: plant_id)
end

# Siembra la tabla de usuarios
300.times do |n|
  nombre = Faker::Name.first_name
  p_apellido = Faker::Name.last_name
  s_apellido = Faker::Name.last_name
  tel = Faker::PhoneNumber.phone_number
  email = p_apellido + "_" + n.to_s + "@mail.com" 
  permiso = rand(2..6)
  cliente_id = 9
  User.create!(nombre: nombre, p_apellido: p_apellido, s_apellido: s_apellido,
  tel: tel, email: email, permiso: permiso, cliente_id: cliente_id)
end

tipo_incidente = ["Óxido","Barreno Adicional","Raya","Golpe","Contaminada",
"Porosidad","Mal Acabado","Falta de Material","Rebaba","Altura Incorrecta", 
"Sin Marca de Garantía","Grietas","Pozo","Cuerda Averiada","Longitud Incorrecta",
"Carbonizado"]

# Siembra la tabla de tipos de incidentes
tipo_incidente.length.times do |n|
  IncidentType.create!(tipo: tipo_incidente[n])
end
cont = 0
# Siembra las tablas solicitudes, cotizaciones y reportes para 4 meses
(4.months.ago.to_date..Date.current).each do |date|
  # Sección del cliente
  cliente_id = rand(1..99)
  incident_type_id = rand(1..tipo_incidente.length)
  part_id = rand(1..99)
  inventario = rand(100..2000)
  solicitud = Request.create!(ayuda_visual: "nada", consumo: "", inventario: inventario, lote: "",
    metodo: "", serie: "", cliente_id: cliente_id, incident_type_id: incident_type_id,
    part_id: part_id)

  # Sección de la cotización
  orden_compra = rand(1000..9000)
  precio = rand(10..200)
  iva = 16
  sub_total = inventario*precio
  total = sub_total*(1+iva/100)
  cotizacion = Quotation.create!(cliente_id: cliente_id, fecha_cotizada: date,
    fecha_orden: date, inventario: inventario, iva: iva, modo_cobro: "",
    orden_compra: orden_compra, precio: precio, request_id: solicitud.id,
    sub_total: sub_total, total: total)

  # Sección del reporte
  usuario = rand(1..300)
  reporte = Report.create!(capturando: false, fecha_inicio: date, quotation_id: cotizacion.id, status: "ESPERA", user_id: usuario)
  total_basura = 0
  total_incidentes = 0
  total_inspeccion = 0
  total_ng = 0
  total_ok = 0
  total_recupera = 0
  lote = rand(10000..99000)

  if( cont%4 == 0 ) # cada cuatro reportes genera datos de inspección
    
    5.times do |item| # Gnera 5 items por cada inspección
      ng = rand(6..20)
      ok = rand(200..500)
      recuperadas = rand(1..5)
      scrap = ng - recuperadas
      inspecciones = ok + ng
      incidentes = rand(1..5)
      lote_prod1 = "LP1-#{lote}"
      lote_prod2 = "LP2-#{lote}"
      inspec = Inspection.create!(incidentes: incidentes, inspecciones: inspecciones, lote: lote, lote_prod1: lote_prod1, lote_prod2: lote_prod2, ng: ng, ok: ok, num_item: item+1, recuperadas: recuperadas, report_id: reporte.id, scrap: scrap)
      
      incidentes.times do |i|
        tipo = rand(1..tipo_incidente.length)
        incidente = Incident.create!(cantidad: 1, incident_type_id: tipo, inspection_id: inspec.id)
      end
      total_basura += scrap
      total_incidentes += incidentes
      total_inspeccion += inspecciones
      total_ng += ng
      total_ok += ok
      total_recupera += recuperadas
    end
    reporte.update(total_basura: total_basura, total_incidentes: total_incidentes, total_inspeccion: total_inspeccion, total_ng: total_ng, total_ok: total_ok, total_recupera: total_recupera, status: "INSPEC")
  end
  cont += 1
end

