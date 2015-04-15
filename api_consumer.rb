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


test_response = {
   "code" => "OK" ,
   "message" => "OK",
   "count" => 1,
   "pages" => 1,
   "information" => {
    "app_name" => "SP Test App" ,
    "appid" => 157,
    "virtual_currency" => "Coins",
    "country" => " US" ,
    "language" => " EN" ,
    "support_url" => "http://iframe.sponsorpay.com/mobile/DE/157/my_offers"
   },
   "offers" => [
    {
      "title" => "Tap  Fish",
      "offer_id" => 13554,
      "teaser" => "Download and START" ,
      "required_actions" => "Download and START",
      "link" => "http://iframe.sponsorpay.com/mbrowser?appid=157&lpid=11387&uid=player1",
      "offer_types" => [
       {
        "offer_type_id" => 101,
        "readable" => "Download"
       },
       {
        "offer_type_id" => 112,
        "readable" => "Free"
       }
      ] ,
      "thumbnail" => {
       "lowres" => "http://cdn.sponsorpay.com/assets/1808/icon175x175-2_square_60.png",
       "hires" => "http://cdn.sponsorpay.com/assets/1808/icon175x175-2_square_175.png"
      },
      "payout" => 90,
      "time_to_payout" => {
       "amount" => 1800 ,
       "readable" => "30 minutes"
      }
    }
   ]
  }

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
  erb :empty, :layout=>:layout
end


post '/offers' do
  content_type :json
  params =  JSON.parse(request.body.read)
  safe_params = params.select{|key,value| ['uid','pub0','page'].include?(key) }
  Offer.config_params( settings.api_key, device_params.merge(safe_params) )
  Offer.search().to_json
end