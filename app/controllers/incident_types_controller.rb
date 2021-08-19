class IncidentTypesController < ApplicationController
  
  def index
    selec_listado
  end

  def show
    @incident_type = IncidentType.find(params[:id])
  end

  def new
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @incident_type = IncidentType.new
  end

  def create
    @incident_type = IncidentType.new(incident_type_params)
    @incident_types = IncidentType.all #Se requiere para desplegar la segunda tarjeta
    if @incident_type.save
      redirect_to @incident_type
    else
      render :new
    end
  end

  def edit
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @incident_type = IncidentType.find(params[:id])
  end

  def update
    @incident_type = IncidentType.find(params[:id])
    #Se requiere para desplegar la segunda tarjeta, en el caso de render :new
    @incident_types = IncidentType.all
    if @incident_type.update(incident_type_params)
      redirect_to @incident_type
    else
      render :new
    end
  end

  def destroy
    @incident_type = IncidentType.find(params[:id])
    @incident_type.destroy
    redirect_to incident_types_path
  end

  private
  
    def incident_type_params
      params.require(:incident_type).permit(:tipo)
    end

    # selec_listado(): Se selecciona toda la tabla o solo registros con una cadena de busqueda
    def selec_listado
      cadena_busqueda = params[:busca]
      if( !cadena_busqueda || cadena_busqueda == '' ) # Si no hay instruccion de búsqueda, se selcciona toda la tabla
        @incident_types = IncidentType.all
      else 
        # Manera segura del LIKE. El segundo argumento reemplaza el ?, de esta manera no se pueden 
        # introduir caracteres maliciosos. El comodin % delate y atras forma un patrón.
        @incident_types = IncidentType.where("tipo LIKE ?", 
          "%#{cadena_busqueda}%")
      end

    end

end
