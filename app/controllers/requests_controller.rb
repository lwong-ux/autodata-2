class RequestsController < ApplicationController
  def index
    selec_listado
  end

  def show
    @request = Request.find(params[:id])
  end

  def new
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @request = Request.new
  end

  def create
    @request = Request.new(request_params)
    @requests = Request.all #Se requiere para desplegar la segunda tarjeta
    if @request.save
      redirect_to @request
    else
      render :new
    end
  end

  def edit
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @request = Request.find(params[:id])
  end

  def update
    @request = Request.find(params[:id])
    #Se requiere para desplegar la segunda tarjeta, en el caso de render :new
    @requests = Request.all
    if @request.update(request_params)
      redirect_to @request
    else
      render :new
    end
  end

  def destroy
    @request = Request.find(params[:id])
    @request.destroy
    redirect_to requests_path
  end

  private
  
    def request_params
      params.require(:request).permit(:cliente_id, :part_id, :serie, :lote, 
        :inventario, :incident_type_id, :ayuda_visual, :metodo, :consumo)
    end

    # selec_listado(): Selecciona toda la tabla o solo registros 
    #                  con una cadena de busqueda
    def selec_listado
      cadena_busqueda = params[:busca]
      if( !cadena_busqueda || cadena_busqueda == '' ) # Si no hay instruccion de búsqueda, se selcciona toda la tabla
        #@requests = Request.all
        @requests = Request.paginate(page: params[:page])
      else 
        # Manera segura del LIKE. El segundo argumento reemplaza el ?, de esta manera no se pueden 
        # introduir caracteres maliciosos. El comodin % delate y atras forma un patrón.
        @requests = Request.where("id LIKE ?", 
          "%#{cadena_busqueda}%").or(Request.where("serie LIKE ?", 
            "%#{cadena_busqueda}%")).paginate(page: params[:page])
          
      end

    end
end
