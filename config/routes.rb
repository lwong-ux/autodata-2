Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "autodat#inicio"
  get "/autodat", to: "autodat#inicio"
  
  resources :clientes
  resources :plants
  resources :parts
  resources :users
  resources :incident_types
  resources :requests
  
  resources :quotations
  get "/quotations/crear_desde_solicitudes/:id", to: "quotations#crear_desde_solicitudes"
  get "/quotations/envia_cotiza/:id", to: "quotations#envia_cotiza", as: "envia_cotiza"
  get "/quotations/envia_correo/:id", to: "quotations#envia_correo", as: "envia_correo"
  
  resources :reports
  get "/reports/crear_desde_cotizaciones/:id", to: "reports#crear_desde_cotizaciones", as: 'crear_desde_cot'
  get "/reports/envia_reporte/:id", to: "reports#envia_reporte", as: 'envia_reporte'
  get "/reports/envia_correo_reporte/:id", to: "reports#envia_correo_reporte", as: "envia_correo_reporte"

  resources :inspections
  get "incidentes", to: "inspections#incidentes"
  get "/inspections/termina_reporte/:id", to: "inspections#termina_reporte", as: "termina_reporte"

end
