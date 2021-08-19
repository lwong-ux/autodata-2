# Los parámetros para habilitar un server de email se declaran en: /config/environments/development.rb
class UserMailer < ApplicationMailer
    default from: 'wong.instruments@gmail.com'
  
    def cotiza_email
      @cotiza = params[:cotiza]
      @url  = 'wonginstruments.com'

      attachments["cotiza_#{@cotiza.id}.pdf"] = WickedPdf.new.pdf_from_string(
        render_to_string(pdf: 'cotiza', template: "quotations/envia_cotiza.html.erb", layout: 'pdf.html')
      )

      mail(to: 'linowong@me.com', subject: 'Cotización solicitada')
    end 

    def reporte_email
      @report = params[:report]
      @url  = 'wonginstruments.com'
      @items = Array.new
      @tipos = Array.new
      @total_tipo = Array.new
      @tabla_final = Array.new{Array.new}
      @plot = Array.new{Hash.new}
      crea_tabla_incidentes

      attachments["reporte_#{@report.id}.pdf"] = WickedPdf.new.pdf_from_string(
        render_to_string(pdf: 'report', template: 'reports/envia_reporte.html.erb', layout: 'pdf.html')
      )

      mail(to: 'linowong@me.com', subject: 'Reporte solicitado')
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
