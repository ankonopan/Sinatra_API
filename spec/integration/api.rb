require_relative '../../api_consumer.rb' # this load the file you are testing
require_relative '../spec_helper.rb' # It will load the configuration you set in spec_helper.rb


describe "Frontend" do
  it "should return the home page" do
    get "/"
    binding.pry
    last_response.should be_ok # it will true if the home page load successfully
  end
end

describe 'API response' do
  it "should return a list of ads" do # the first test
    post '/ads' # you are visiting the home page
    last_response.should be_ok # it will true if the home page load successfully
  end
end