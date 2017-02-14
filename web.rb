require 'sinatra'
require 'sendgrid-ruby'
require 'json'
require 'sinatra/cross_origin'

configure do
  enable :cross_origin
end

post '/mail' do
  cross_origin
  request.body.rewind
  message = JSON.parse(request.body.read)

  content_txt =<<-HEREDOC
  <p>
Mensaje de: <b>#{ message["name"] }</b>
  </p>
  <p>
Teléfono:      <b>#{ message["phone"] }</b>
  </p>
  <p>
Mensaje:
  </p>
  <p>
#{ message["message"] }
  </p>
HEREDOC

  data = JSON.parse('{
    "personalizations": [
      {
        "to": [
          {
            "name": "Luis Espinoza",
            "email": "luchito.bo@gmail.com"
          },
          {
            "name": "DEV",
            "email": "mr@zenlabs.net"
          }
        ],
        "subject": "Nuevo mensaje desde la appMobile"
      }
    ],
    "from": {
      "email": "no-reply@appContigo.com"
    },
    "content": [
      {
        "type": "text/html",
        "value": ""
      }
    ]
  }')

  data['content'][0]['value'] = content_txt
  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  response = sg.client.mail._("send").post(request_body: data)

  content_type :json
  {
    response: 'message was sent successfully.',
    api: response.inspect
  }.to_json
end
