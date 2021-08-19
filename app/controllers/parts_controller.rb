class PartsController < ApplicationController
  
  def index
    selec_listado
  end

  def show
    @part = Part.find(params[:id])
  end

  def new
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @part = Part.new
  end

  def create
    @part = Part.new(part_params)
    @parts = Part.all #Se requiere para desplegar la segunda tarjeta
    if @part.save
      redirect_to @part
    else
      render :new
    end
  end

  def edit
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @part = Part.find(params[:id])
  end

  def update
    @part = Part.find(params[:id])
    #Se requiere para desplegar la segunda tarjeta, en el caso de render :new
    @parts = Part.all
    if @part.update(part_params)
      redirect_to @part
    else
      render :new
    end
  end

  def destroy
    @part = Part.find(params[:id])
    @part.destroy
    redirect_to parts_path
  end

  private

    def part_params
      params.require(:part).permit(:num_parte, :nombre, :plant_id)
    end

    # selec_listado(): Se selecciona toda la tabla o solo registros con una cadena de busqueda
    def selec_listado
      cadena_busqueda = params[:busca]
      if( !cadena_busqueda || cadena_busqueda == '' ) # Si no hay instruccion de búsqueda, se selcciona toda la tabla
        @parts = Part.paginate(page: params[:page])
      else 
        # Manera segura del LIKE. El segundo argumento reemplaza el ?, de esta manera no se pueden 
        # introduir caracteres maliciosos. El comodin % delate y atras forma un patrón.
        @parts = Part.where("nombre LIKE ?", 
          "%#{cadena_busqueda}%").or(Part.where("num_parte LIKE ?", 
            "%#{cadena_busqueda}%")).paginate(page: params[:page])
      end
    end
end
