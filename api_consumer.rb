require 'sinatra'
require 'pry'
require 'active_resource'
require 'activeresource-response'
require "sinatra/config_file"


require_relative "model/offer.rb"

ActiveResource::Base.logger = Logger.new(STDOUT)

configure :development do

  enable :sessions
  set :session_secret, "asdfasfd asfda sfd asfd asfda"

end
config_file 'config/params.yml'


def device_params
  {
    "appid" => settings.appid,
    "locale" => settings.locale,
    "device_id" => "2b6f0cc904d137be2e1730235f5664094b83",
    "ip" => "109.235.143.113",
    "os_version" => 6.0
  }
end

get '/' do
  ""
end


post '/offers' do
  safe_params = params.select{|key,value| ['uid','pub0','page'].include?(key) }
  Offer.config_params( settings.api_key, device_params.merge(safe_params) )
  Offer.search().to_json
end