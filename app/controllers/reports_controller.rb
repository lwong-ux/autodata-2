class ReportsController < ApplicationController

  def index
    selec_listado
  end

  def show
    @report = Report.find(params[:id])
  end

  def new
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    @reports = Report.all #Se requiere para desplegar la segunda tarjeta
    @report.status = "ESPERA"
    if @report.save
      redirect_to @report
    else
      render :new
    end
  end

  def edit
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @report = Report.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])
    #Se requiere para desplegar la segunda tarjeta, en el caso de render :new
    @reports = Report.all

    if @report.update(report_params)
      redirect_to @report
    else
      render :new
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report.destroy
    redirect_to reports_path
  end

  #   crear_desde_cotizaciones()
  # Este método crea un nuevo reporte ligado a un número de cotización (:id). 
  # Se invoca desde COTIZACIONES y no pasa por el proceso CRUD de las rutas de Rails.
  def crear_desde_cotizaciones
    @report = Report.new
    # Si el No. de la cotización (quotation_id) ya existe, es decir no está vacio,
    #   se invoca la vista correspondiente la cual es una alerta.
    if Report.find_by(quotation_id: params[:id]).to_s.empty? == false
       @report.id =  Report.find_by(quotation_id: params[:id]).id
      # Llamado al "view" para alertar y redirigir al No. de cotización
    else
      # Recupera el id de la cotización
      @report.quotation_id = params[:id] 
      @report.user_id = 3
      @report.status = "ESPERA"
      @report.fecha_inicio = Time.zone.now
 
      #Se requiere para desplegar la segunda tarjeta, en el caso de render :new
      @reports = Report.all
      if @report.save   
        redirect_to @report
      else
        render :new
      end
    end
  end

  def envia_correo_reporte
    @report = Report.find(params[:id])
   
    UserMailer.with(report: @report).reporte_email.deliver
  end

  def envia_reporte
    @report = Report.find(params[:id])
    @formato_html = true
    @items = Array.new
    @tipos = Array.new
    @total_tipo = Array.new
    @tabla_final = Array.new{Array.new}
    @plot = Array.new{Hash.new}
    crea_tabla_incidentes

    respond_to do |format|
      format.html 
      format.pdf do
          @formato_html = false
          render pdf: "Invoice No. #{@report.id}",
            template: "reports/envia_reporte.html.erb",
            layout: "pdf.html.erb",
            lowquality: true,
            zoom: 1,
            dpi: 75
          
          
      end
    end
  end

  private
  
    def report_params
      params.require(:report).permit(:user_id, :turno, :fecha_inicio, :fecha_termino, :quotation_id )
    end

    # selec_listado(): Se selecciona toda la tabla o solo registros con 
    # una cadena de busqueda
    def selec_listado
      cadena_busqueda = params[:busca]
      # Si no hay instruccion de búsqueda, se selcciona toda la tabla
      if( !cadena_busqueda || cadena_busqueda == '' ) 
        #@reports = Report.all
        @reports = Report.paginate(page: params[:page])
      else 
        # Manera segura del LIKE. El segundo argumento reemplaza el ?, 
        # de esta manera no se pueden introduir caracteres maliciosos. 
        # El comodin % delate y atras forma un patrón.
        @reports = Report.where("user_id LIKE ?", 
          "%#{cadena_busqueda}%").or(Report.where("quotation_id LIKE ?", 
            "%#{cadena_busqueda}%"))
      end

    end

    def crea_tabla_incidentes
     
      tabla = Array.new{Array.new}

      # Extrae los incidentes correspondientes a cada inspección de items.
      # Genera una tabla irregular: tabla
      # Genera los arreglos: items y tipos
      @report.inspections.each do |inspec|
        item = inspec.num_item
        @items.push(item)
        subarray = []
        inspec.incidents.each do |inci|
          @tipos.push(inci.incident_type.tipo) # Todos los tipos los guarda en un arreglo, aún repetidos
          str = inci.incident_type.tipo+"#{inci.cantidad}"
          subarray.push(str)
          @plot.push(inci.incident_type.tipo => inci.cantidad)
        end
        tabla.push(subarray)
      end

      @tipos.compact! # Elimina nils
      @tipos.uniq!   # Elimina repeticiones
      @tipos.sort!   # Ordena alfabético

      # Inicializa una matriz de tamaño items x tipos: tabla_final
      @items.each do |row|
        subarray = []
        @tipos.each do |column|
          subarray.push(0)
        end
        @tabla_final.push(subarray)
      end

      # Llena la matriz con los incidentes segun corresponda a su tipo
      i=j=0
      tabla.each do |row|
        subarray = []
        row.each do |column|
          @tipos.each do |t|
            if column.include? t
              @tabla_final[i][j] = column.delete t
              if @total_tipo[j].nil?
                @total_tipo[j] = @tabla_final[i][j].to_i
              else
                @total_tipo[j] += @tabla_final[i][j].to_i
              end
            end
            j += 1
          end
          j = 0
        end
        i += 1
      end

    end

end