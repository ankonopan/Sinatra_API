require 'sinatra'
require 'pry'


configure :development do

  enable :sessions
  set :session_secret, "asdfasfd asfda sfd asfd asfda"

end


get '/' do
  ""
end