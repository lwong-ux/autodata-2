class QuotationsController < ApplicationController
  
  def index
    selec_listado
  end

  def show
    @quotation = Quotation.find(params[:id])
  end

  def new
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @quotation = Quotation.new
  end

  def create
    @quotation = Quotation.new(quotation_params)
    @quotations = Quotation.all #Se requiere para desplegar la segunda tarjeta
    
    # Calculo de sub total y total
    if @quotation.modo_cobro?
      @quotation.sub_total = @quotation.inventario * @quotation.precio
      @quotation.iva = @quotation.sub_total * 0.15
      @quotation.total = @quotation.sub_total + @quotation.iva
    end
    
    if @quotation.save
      redirect_to @quotation
    else
      render :new
    end
  end

  def edit
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @quotation = Quotation.find(params[:id])
  end

  def update
    @quotation = Quotation.find(params[:id])
    #Se requiere para desplegar la segunda tarjeta, en el caso de render :new
    @quotations = Quotation.all

     # Calculo de sub total y total
    if @quotation.modo_cobro?
      @quotation.sub_total = @quotation.inventario * @quotation.precio
      @quotation.iva = @quotation.sub_total * 0.16
      @quotation.total = @quotation.sub_total + @quotation.iva
    end

    if @quotation.update(quotation_params)
      redirect_to @quotation
    else
      render :new
    end
  end

  def destroy
    @quotation = Quotation.find(params[:id])
    @quotation.destroy
    redirect_to quotations_path
  end

  #   crea_desde_solicitudes()
  # Este método crea una nueva cotización ligada a un número de solicitud (:id). 
  # Se invoca de desde SOLICITUDES y no pasa por el proceso CRUD de las rutas de Rails.
  def crear_desde_solicitudes
    @quotation = Quotation.new
    # Si el No. de la solicitud (request_id) ya existe, es decir no está vacio,
    #   se invoca la vista correspondiente la cual es una alerta.
    if Quotation.find_by(request_id: params[:id]).to_s.empty? == false
       @quotation.id =  Quotation.find_by(request_id: params[:id]).id
      # Llamado al "view" para alertar y redirigir al No. de cotización
    else
      
      # Recupera el id de la solicitud
      @quotation.request_id = params[:id] 
      # Extrae el nombre del cliente
      @quotation.cliente_id = Request.find(params[:id]).cliente_id 
      # Extrae el inventario
      @quotation.inventario = Request.find(params[:id]).inventario 
      
      #Se requiere para desplegar la segunda tarjeta, en el caso de render :new
      @quotations = Quotation.all
      if @quotation.save   
        redirect_to @quotation
      else
        render :new
      end
    end
  end

  def envia_correo
    @cotiza = Quotation.find(params[:id])
    UserMailer.with(cotiza: @cotiza).cotiza_email.deliver
  end

  def envia_cotiza
    @cotiza = Quotation.find(params[:id])
    @formato_html = true

    respond_to do |format|
      format.html 
      format.pdf do
          @formato_html = false
          render pdf: "Invoice No. #{@cotiza.id}",
          
          template: "quotations/envia_cotiza.html.erb",
          layout: "pdf.html.erb",
          
          lowquality: true,
          zoom: 1,
          dpi: 75
      end
    end
  end

  private
  
    def quotation_params
      params.require(:quotation).permit(:cliente_id, :request_id, :orden_compra, :fecha_orden, 
        :fecha_cotizada, :modo_cobro, :inventario, :precio, :sub_total, :iva, :total)
    end

    # selec_listado(): Se selecciona toda la tabla o solo registros 
    #                  con una cadena de busqueda
    def selec_listado
      cadena_busqueda = params[:busca]
      # Si no hay instruccion de búsqueda, se selcciona toda la tabla
      if( !cadena_busqueda || cadena_busqueda == '' ) 
        #@quotations = Quotation.all
        @quotations = Quotation.paginate(page: params[:page])
      else 
        # Manera segura del LIKE. El segundo argumento reemplaza el ?, 
        # de esta manera no se pueden introduir caracteres maliciosos. 
        # El comodin % delate y atras forma un patrón.
        @quotations = Quotation.where("id LIKE ?", 
          "%#{cadena_busqueda}%").or(Quotation.where("cliente_id LIKE ?", 
          "%#{cadena_busqueda}%")).or(Quotation.where("request_id LIKE ?", 
            "%#{cadena_busqueda}%")).paginate(page: params[:page])
          
      end

    end
end
