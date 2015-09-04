require 'sinatra/base'
require 'sinatra/json'
require 'net/http'
require 'uri'
require 'json'
require 'jwt'

class AuthzApp < Sinatra::Base

  configure do 
    set :bind, '0.0.0.0'
    set :public_folder, 'public'
  end

  get '/' do
    redirect '/index.html'
  end

  get '/token' do
    auth = request.env['HTTP_AUTHORIZATION'] # rack, y u obscure http header nemz?
    m = auth.match /^facebook\s(.*)/i
    unless m
      status 400
      return json message: 'invalid auth header'
    end

    token = m[1]
    uri = URI('https://graph.facebook.com/')
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Get.new("/v2.4/me?fields=id,name,email&access_token=#{token}")
      http.request(req)
    end

    data = JSON.parse(res.body)
    puts "Facebook replied #{res.code}"
    puts data

    case res
    when Net::HTTPSuccess then
      secret = 'myS3cr37'
      payload = {name: data['name'], email: data['email']}
      token = JWT.encode payload, secret, 'HS256'
      status 200; json({
        message: "Welcome #{data['name']}!", 
        email: data['email'],
        name: data['name'],
        profileUrl: 'https://facebook.com/' + data['id'],
        token: token,
        tokenType: 'Bearer'
      })
    when Net::HTTPClientError then
      status res.code; json message: data['error']['message']
    when Net::HTTPServerError then
      status 502; json message: 'upstream error'
    else 
      status 501; json message: "unsupported response status received (#{res.code})"
    end
  end

end
