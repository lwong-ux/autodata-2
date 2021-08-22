# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
  
  ruby  3.0.0

* System dependencies

* Configuration

  Antes de iniciar, configurar **bundle** para que recuerde no incluir producción en local:
  
  `$ bundle config set --local without production`

* Database creation
  
  `$ rails db:migrate`

* Database initialization

  `$ rails db:seed`

* Git

  Solo una vez por computadora:
  
  `$ git config --global user.name "lwong-ux`
  
  `$ git config --global user.email "wong.instrumnets@gmail.com`
  
  Para recordar las claves por un día:
  
  `git config --global credential.helper "cache --timeout=86400"`

* GitHub

  Para conectar al deposito remoto (origin):

  `$ git remote add origin https://github.com/lwong-ux/autodata-2.git` 
    
  `$ git push -u origin main`
  
  Usr: lwong-ux
  
  psw:  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

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

  Instalar **Heroku** (en caso de que no lo esté), del libro de RoR tutorial:
  
  `$ source <(curl -sL https://cdn.learnenough.com/heroku_install)`
  
