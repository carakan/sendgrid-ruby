require 'sinatra'
require 'sendgrid-ruby'
require 'json'
require 'sinatra/cross_origin'

post '/mail' do
  cross_origin
  request.body.rewind
  message = JSON.parse(request.body.read)

  content_txt =<<-HEREDOC
<span id="catConsulta">#{ message[:name] }</span>
<span id="nombre">#{ message[:email] }</span>
<span id="telefono">#{ message[:message] }</span>
HEREDOC

  data = JSON.parse('{
    "personalizations": [
      {
        "to": [
          {
            "name": "Luis Espinoza",
            "email": "Luchito.bo@gmail.com"
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

  content_type :json
  {
    response: 'message was sent successfully.',
    api: response
  }.to_json
end
