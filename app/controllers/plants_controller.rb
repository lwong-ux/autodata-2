class PlantsController < ApplicationController
 
  def index
    selec_listado
  end
    
  def show
    @plant = Plant.find(params[:id])
  end

  def new
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @plant = Plant.new
  end

  def create
    @plant = Plant.new(plant_params)
    @plants = Plant.all #Se requiere para desplegar la segunda tarjeta
    if @plant.save
      redirect_to @plant
    else
      render :new
    end
  end

  def edit
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @plant = Plant.find(params[:id])
  end

  def update
    @plant = Plant.find(params[:id])
    #Se requiere para desplegar la segunda tarjeta, en el caso de render :new
    @plants = Plant.all
    if @plant.update(plant_params)
      redirect_to @plant
    else
      render :new
    end
  end

  def destroy
    @plant = Plant.find(params[:id])
    @plant.destroy
    redirect_to plants_path
  end

  private

    def plant_params
      params.require(:plant).permit(:nombre, :contacto, :tel, :direccion, :entidad)
    end

    # selec_listado(): Se selecciona toda la tabla o solo registros con una cadena de busqueda
    def selec_listado
      cadena_busqueda = params[:busca]
      if( !cadena_busqueda || cadena_busqueda == '' ) # Si no hay instruccion de búsqueda, se selcciona toda la tabla
        @plants = Plant.paginate(page: params[:page])
      else 
        # Manera segura del LIKE. El segundo argumento reemplaza el ?, de esta manera no se pueden 
        # introduir caracteres maliciosos. El comodin % delate y atras forma un patrón.
        @plants = Plant.where("nombre LIKE ?", 
          "%#{cadena_busqueda}%").or(Plant.where("contacto LIKE ?", 
            "%#{cadena_busqueda}%")).paginate(page: params[:page])
      end
    end
end
