$:.unshift(File.expand_path(File.dirname(__FILE__)))

require 'api_consumer'

# run MyApp
run Sinatra::Application