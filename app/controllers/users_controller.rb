class UsersController < ApplicationController
  def index
    selec_listado
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @user = User.new
    @user.cliente_id = 1
    
  end

  def create
    @user = User.new(user_params)
    @users = User.all #Se requiere para desplegar la segunda tarjeta
    
    if @user.save
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    selec_listado #Se requiere para desplegar la segunda tarjeta
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    #Se requiere para desplegar la segunda tarjeta, en el caso de render :new
    @users = User.all
    
    if @user.update(user_params)
      redirect_to @user
    else
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  private
  
    def user_params
      params.require(:user).permit(:nombre, :p_apellido, :s_apellido, :tel, :email, 
        :usuario, :clave, :permiso, :cliente_id)
    end

    # selec_listado(): Se selecciona toda la tabla o solo registros con una cadena de busqueda
    def selec_listado
      cadena_busqueda = params[:busca]
      if( !cadena_busqueda || cadena_busqueda == '' ) # Si no hay instruccion de búsqueda, se selcciona toda la tabla
        @users = User.paginate(page: params[:page])
      else 
        # Manera segura del LIKE. El segundo argumento reemplaza el ?, de esta manera no se pueden 
        # introduir caracteres maliciosos. El comodin % adelate y atrás forma un patrón.
        @users = User.where("nombre LIKE ?", 
          "%#{cadena_busqueda}%").or(User.where("usuario LIKE ?", 
            "%#{cadena_busqueda}%")).paginate(page: params[:page])
      end

    end
end
