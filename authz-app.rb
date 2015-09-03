require 'sinatra/base'
require 'sinatra/json'
require 'net/http'
require 'uri'
require 'json'

class AuthzApp < Sinatra::Base

  configure do 
    set :bind, '0.0.0.0'
    set :public_folder, 'public'
  end

  get '/' do
    redirect '/index.html'
  end

  get '/token' do
    auth = request.env['HTTP_AUTHORIZATION']
    m = auth.match /^facebook\s(.*)/i
    unless m
      status 400
      return json message: 'invalid auth header'
    end

    token = m[1]
    puts "Token: #{token}"

    uri = URI('https://graph.facebook.com/')
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Get.new("/v2.4/me?access_token=#{token}")
      http.request(req)
    end

    puts res.code
    puts res.class.name
    data = JSON.parse(res.body)
    puts data

    case res
    when Net::HTTPSuccess then
      status 200; json message: "Welcome #{data['name']}!"
    when Net::HTTPClientError then
      status res.code; json message: data['error']['message']
    when Net::HTTPServerError then
      status 502; json message: 'upstream error'
    else 
      status 501; json message: "unsupported response status received (#{res.code})"
    end
  end

end
