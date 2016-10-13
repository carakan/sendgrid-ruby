require 'sinatra'
require 'sendgrid-ruby'
require 'json'

post '/mail' do

  content_txt =<<-HEREDOC
<span id="webOrigen">shop.nestle.com.ar</span>
<span id="catConsulta">#{ params[:contact][:Motivo1] }</span>
<span id="nombre">#{ params[:contact][:name] }</span>
<span id="telefono">#{ params[:contact][:phone] }</span>
<span id="email">#{ params[:contact][:email] }</span>
<span id="tipoConsulta">#{ params[:contact][:Motivo1] }</span>
<span id="motConsulta">#{ params[:contact][:Motivo2] }</span>
<span id="consulta">#{ params[:contact][:body] }</span>
<span id="datProd"></span>
HEREDOC

  data = JSON.parse('{
    "personalizations": [
      {
        "to": [
          {
            "name": "Mario Postay",
            "email": "Mario.postay@ogilvy.com"
          },
          {
            "name": "Martin Taborda",
            "email": "Martin.Taborda@uy.nestle.com"
          },
          {
            "name": "Edgardo Alcocer",
            "email": "Edgardo.Alcocer@ar.nestle.com"
          },
          {
            "name": "Diego Maldonado",
            "email": "diego.maldonado@brandigital.com"
          }
        ],
        "subject": "Nuevo mensaje desde el formulario de contacto"
      }
    ],
    "from": {
      "email": "no-reply@nestle.com.ar"
    },
    "content": [
      {
        "type": "text/plain",
        "value": ""
      }
      {
        "type": "text/html",
        "value": ""
      }
    ]
  }');

  data["content"][0]["value"] = content_txt
  data["content"][1]["value"] = content_txt
  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  response = sg.client.mail._("send").post(request_body: data)

  redirect 'https://nestle-newdemo.myshopify.com/pages/contacto?email=sent#sent'
end
