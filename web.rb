require 'sinatra'
require 'sendgrid-ruby'
include SendGrid
require 'json'

post '/mail' do
data = JSON.parse('{
  "personalizations": [
    {
      "to": [
        {
          "name": "Carlos RAmos",
          "email": "carakan@gmail.com"
        },
        {
          "name": "Carlos RAmosa",
          "email": "esdecarlos@hotmail.com"
        },
        {
          "name": "Carlos RAmosa 2",
          "email": "carlos.ramos@validoc.net"
        }
      ],
      "subject": "Hello World from the SendGrid Ruby Library!"
    }
  ],
  "from": {
    "email": "test@example.com"
  },
  "content": [
    {
      "type": "text/plain",
      "value": "Hello, Email! blablabla"
    }
  ]
}')
sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
response = sg.client.mail._("send").post(request_body: data)

  from = Email.new(email: 'no-reply@nestle.com.ar')
  subject = 'Mensaje de ' + params[:contact][:name]
  to = Email.new(email: ['carlos.ramos@validoc.net', 'carakan@gmail.com', 'esdecarlos@hotmail.com'])
      
  content = Content.new(type: 'text/plain',
                        value: <<-HEREDOC
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
                          )
  mail = Mail.new(from, subject, to, content)

  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  response = sg.client.mail._('send').post(request_body: mail.to_json)
  redirect 'https://nestle-newdemo.myshopify.com/pages/contacto?email=sent#sent'
end