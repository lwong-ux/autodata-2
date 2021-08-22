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

* GitHub

  Para conectar al deposito remoto (origin):

  `$ git remote add origin https://github.com/lwong-ux/autodata-2.git` 
    
  `$ git push -u origin main`
  
  Usr: lwong-ux
  
  psw: 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

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

  Instalar **Heroku** (en caso de que no lo esté), del libro de RoR tutorial:
  
  `$ source <(curl -sL https://cdn.learnenough.com/heroku_install)`
  
