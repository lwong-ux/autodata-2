# README

* **Ruby**

  El sistema recomedó actualizar ruby. Se generó el siguiente comando:
  
  `$ rvm install "ruby-3.0.0"`
  
  ruby  3.0.0

* **Database**
  
  `$ rails db:migrate`

* **Database inicialización**

  `$ rails db:seed`

* **Git**

  Solo una vez por computadora:
  
  `$ git config --global user.name "lwong-ux"`
  
  `$ git config --global user.email "wong.instrumnets@gmail.com"`
  
  Para recordar las claves por un día:
  
  `$ git config --global credential.helper "cache --timeout=86400"`
  
  Se descargo la versión respaldada en GitHub:
  
  `$ git clone https://github.com/lwong-ux/autodata-2.git`

* **GitHub**

  Para conectar al deposito remoto (origin):

  `$ git remote add origin https://github.com/lwong-ux/autodata-2.git` 
    
  `$ git push -u origin main`
  
  Usr: lwong-ux
  
  psw:  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

  
* **Webpacker**
    
  El mensaje de error: Webpacker::Manifest::MissingEntryError in Autodat#inicio,
  se elimina con:

  `$ rails webpacker:install`
  
* **Bundler**

  Antes de iniciar, configurar **bundle** para que recuerde no incluir producción en local:
  
  `$ bundle config set --local without production`

  Bundler recomendó actualizar de versión. Se realizó el siguiente comando:
  
  `$ gem install bundler:2.2.17`
  
* **wkhtmltopdf**

  Para instalar en Ubuntu 18 (AWS Cloud9)
  
    `$ wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb`
  
    `$ sudo dpkg -i wkhtmltox_0.12.5-1.bionic_amd64.deb`
  
  Para instalar en la RaspberryPi

    `sudo apt-get install wkhtmltopdf`

  Para producción (Heroku) funcina bien la gema "wkhtmltopdf-binary"
  
* **Heroku**

  Para instalar Heroku 
    
    En Ubuntu (Recomendación del libro Ruby on Rails tutorials):
  
      $ source <(curl -sL https://cdn.learnenough.com/heroku_install)

    En RaspberryPi:  Se ejecuta primero solo el comando "curl", enviando la información a un nuevo archivo (instala_heroku). Se edita instala_heroku para cambiar el paquete fuente: reemplazar "x64" por "arm" en todos lados. Se jecuta el nuevo archivo con "source".

      $ curl -sL https://cdn.learnenough.com/heroku_install  > instala_heroku

      $ sudo nano instala_heroku

      $ source instala_heroku
  
  Para ingresar a Heroku desde CLI
  
  `$ heroku login -i`
  
  Para vincular esta aplicación con una particular de Heroku:
  
  `$ heroku git:remote -a powerful-coast-18663`
  
  Para eliminar un remoto a heroku
  
  `git remote rm heroku`
  
  Distribuir (deployment)
  
  `$ git push heroku main`

  Finalmente se inicializa la base de datos con:

  `$ heroku run rails db:migrate`

  `$ heroku run rails db:seed`