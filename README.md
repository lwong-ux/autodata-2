# README

* **Ruby**

  El sistema recomedó actualizar ruby. Se genero el siguiente comando:
  
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

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

  Instalar **Heroku** (en caso de que no lo esté), del libro de RoR tutorial:
  
  `$ source <(curl -sL https://cdn.learnenough.com/heroku_install)`
  
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

  Para instalar en Ubuntu 18
  
  `$ wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb`
  
  `$ sudo dpkg -i wkhtmltox_0.12.5-1.bionic_amd64.deb`
  
* **Heroku**

  Para instalar Heroku (del libro Ruby on Rails Tutorial...:
  
  `$ source <(curl -sL https://cdn.learnenough.com/heroku_install)`
  
  Para ingresar a Heroku desde CLI
  
  `$ heroku login -i`
  
  Para vincular esta aplicación con una particular de Heroku:
  
  `$ heroku git:remote -a young-headland-09640`