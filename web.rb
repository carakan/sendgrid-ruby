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
Mensaje de: #{ message["name"] }

Email:      #{ message["email"] }

Mensaje:

#{ message["message"] }
HEREDOC

  data = JSON.parse('{
    "personalizations": [
      {
        "to": [
          {
            "name": "Luis Espinoza",
            "email": "carakan@gmail.com"
          },
          {
            "name": "Luis Espinoza",
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
        "type": "text/plain",
        "value": ""
      },
      {
        "type": "text/html",
        "value": ""
      }
    ]
  }')

  data['content'][0]['value'] = content_txt
  data["content"][1]["value"] = content_txt
  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  response = sg.client.mail._("send").post(request_body: data)

  content_type :json
  {
    response: 'message was sent successfully.',
    api: response.inspect
  }.to_json
end
