class ClientesController < ApplicationController

  def index
    selec_listado
  end

  def show
    @cliente = Cliente.find(params[:id])
  end

  def new
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @cliente = Cliente.new
  end

  def create
    @clientes = Cliente.paginate(page: params[:page])
    @cliente = Cliente.new(cliente_params) #Se requiere para desplegar la segunda tarjeta compatible con paginate
    if @cliente.save
      redirect_to @cliente
    else
      render :new
    end
  end

  def edit
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @cliente = Cliente.find(params[:id])
  end

  def update
    @cliente = Cliente.find(params[:id])
    #Se requiere para desplegar la segunda tarjeta, en el caso de render :new
    @clientes = Cliente.all
    if @cliente.update(cliente_params)
      redirect_to @cliente
    else
      render :new
    end
  end

  def destroy
    @cliente = Cliente.find(params[:id])
    @cliente.destroy
    redirect_to clientes_path
  end

  private
  
    def cliente_params
      params.require(:cliente).permit(:nombre, :contacto, :tel, :direccion, :entidad)
    end

    # selec_listado(): Se selecciona toda la tabla o solo registros con una cadena de busqueda
    def selec_listado
      cadena_busqueda = params[:busca]
      if( !cadena_busqueda || cadena_busqueda == '' ) # Si no hay instruccion de búsqueda, se selcciona toda la tabla
        #@clientes = Cliente.all
        @clientes = Cliente.paginate(page: params[:page])
      else 
        # Manera segura del LIKE. El segundo argumento reemplaza el ?, de esta manera no se pueden 
        # introduir caracteres maliciosos. El comodin % delate y atras forma un patrón.
        @clientes = Cliente.where("nombre LIKE ?", 
          "%#{cadena_busqueda}%").or(Cliente.where("contacto LIKE ?", 
            "%#{cadena_busqueda}%")).paginate(page: params[:page])
      end

    end
end
