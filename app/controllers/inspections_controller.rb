class InspectionsController < ApplicationController
  
  def index 
    selec_listado
  end

  def show
    @report = Report.find(params[:id])
  end

  def new
    @capturando = true
    #selec_listado #Se requiere para desplegar la segunda tarjeta
    @report = Report.new
    @report = Report.find(params[:format])
    @inspection = Inspection.new
    @inspection.ok = 0
    @inspection.ng = 0
    @inspection.recuperadas = 0
    @inspection.scrap = 0
    @num_item = @report.inspections.length + 1
    @tipoIncidente = []
    @cantidadIncidente = []
  end

  def create
    @inspection = Inspection.new(inspection_params)
    @inspection.inspecciones = @inspection.ok + @inspection.ng
    @inspection.incidentes = totalIncidentes
    if @inspection.save
      recuperaIncidentes
      actualizaReporte
      redirect_to action: "new", format: @inspection.report_id
    else
      render :new
    end
  end

  def edit
    @capturando = true
    @inspection = Inspection.find(params[:id])
    @report = Report.find(@inspection.report_id)
    
    @num_item = @inspection.num_item
    @tipoIncidente = []
    @cantidadIncidente = []
    recuperaIncidentesEdit
  end

  def update
    @inspection = Inspection.find(params[:id])
    @inspection.incidentes = totalIncidentes
    if @inspection.update(inspection_params)
      # inspecciones (total) no existe en los parámetros de captura por tanto se actualiza en update. Es necesario sumar ok con ng y respaldar (save).
      @inspection.inspecciones = @inspection.ok + @inspection.ng
      @inspection.save
      recuperaIncidentesUpdate
      actualizaReporte
      redirect_to action: "new", format: @inspection.report_id
    else
      render :new
    end
  end

  # Se utiliza para limpiar el ITEM en captura y preparar uno nuevo
  def destroy
    @inspection = Inspection.find(params[:id])
    #@inspection.destroy
    redirect_to action: "new", format: @inspection.report_id
  end

  def incidentes
    @item = params[:item].to_i - 1
    @numRepo = params[:numRepo].to_i
    @report = Report.find(@numRepo)
    @inspetion = @report.inspections[@item]
  end

  def termina_reporte
    @report = Report.find(params[:id])
    @report.fecha_termino = Time.zone.now
    @report.status = "TERMINADO"
    if( @report.save)
      redirect_to action: "index"
    else
      render :new
    end
  end

  private
  
    def inspection_params
      params.require(:inspection).permit(:num_item, :lote, :lote_prod1, :lote_prod2, :inspecciones, :ok, :ng, :recuperadas, :scrap, :incidentes, :report_id)
    end

    # selec_listado(): Se selecciona toda la tabla o solo registros con 
    # una cadena de busqueda
    def selec_listado
      cadena_busqueda = params[:busca]
      # Si no hay instruccion de búsqueda, se selcciona toda la tabla
      if( !cadena_busqueda || cadena_busqueda == '' ) 
        #@reports = Report.all
        @reports = Report.paginate(page: params[:page])
        @inspections = @reports
      else 
        # Manera segura del LIKE. El segundo argumento reemplaza el ?, 
        # de esta manera no se pueden introduir caracteres maliciosos. 
        # El comodin % delate y atras forma un patrón.
        @reports = Report.where("user_id LIKE ?", 
          "%#{cadena_busqueda}%").or(Report.where("quotation_id LIKE ?", 
            "%#{cadena_busqueda}%"))
      end

    end
   
    # recuperaIncidentes(): Extrae de params los contadores de incidente, los suma y graba
    def totalIncidentes
      total = 0
      numIncidente = ["eAmarillo", "eAmber", "eOrange", "eLime", "eAqua", "eBlue", "eCyan","eTeal"]

      (0..7).each do |i|
        cantidad = params[numIncidente[i]].to_i
        total += cantidad
      end
      return total
    end

    # recuperaIncidentes(): Extrae de params los contadores de incidente, los suma y graba
    def recuperaIncidentes
      numIncidente = ["eAmarillo", "eAmber", "eOrange", "eLime", "eAqua", "eBlue", "eCyan","eTeal"]
      tipoIncidente = ["amarillo", "amber", "orange", "lime", "aqua", "blue", "cyan","teal"]

      (0..7).each do |i|
        cantidad = params[numIncidente[i]].to_i
        if cantidad > 0
          tipo = IncidentType.find_by(tipo: params[tipoIncidente[i]])
          Incident.create(cantidad: cantidad, 
              inspection_id: @inspection.id,
              incident_type_id: tipo.id)
          
        end
      end
    end

    # recuperaIncidentes(): Extrae de params los contadores de incidente, los suma y graba
    def recuperaIncidentesEdit
      i=0
      @inspection.incidents.each do |incident|
        @cantidadIncidente[i] = incident.cantidad
        @tipoIncidente[i] = IncidentType.find(incident.incident_type_id).tipo
        i += 1
      end
    end

    # recuperaIncidentesUpdate(): Extrae de params los contadores de incidente, los suma y actualiza
    def recuperaIncidentesUpdate
      numIncidente = ["eAmarillo", "eAmber", "eOrange", "eLime", "eAqua", "eBlue", "eCyan","eTeal"]
      tipoIncidente = ["amarillo", "amber", "orange", "lime", "aqua", "blue", "cyan","teal"]

      # Primero borrar los anteriores
      @inspection.incidents.each do |incident|
        incident.destroy
      end

      (0..7).each do |i|
        cantidad = params[numIncidente[i]].to_i
        if cantidad > 0
          tipo = IncidentType.find_by(tipo: params[tipoIncidente[i]])
          Incident.create(cantidad: cantidad, 
              inspection_id: @inspection.id,
              incident_type_id: tipo.id)
          
        end
      end
    end
    
    def actualizaReporte
      ok=ng=recuperadas=scrap=incidentes=0
      report = Report.find(@inspection.report_id)
      report.inspections.each do |inspection|
        ok += inspection.ok
        ng += inspection.ng
        recuperadas += inspection.recuperadas
        scrap += inspection.scrap
        incidentes += inspection.incidentes
      end
      report.update(status: "INSPEC", total_inspeccion: ok+ng, total_ok: ok, total_ng: ng,total_recupera: recuperadas, total_basura: scrap, total_incidentes: incidentes)
    end

end