require_relative '../../api_consumer.rb' # this load the file you are testing
require_relative '../spec_helper.rb' # It will load the configuration you set in spec_helper.rb

set :environment, :test # setting the environment in which the test will run
config_file 'config/params.yml'

describe "Offer" do

  it "should calculate the hash key" do
    Offer.config_params("12345", "appid" => "34")
    Offer.calculate_hash_query().tap do |query|
      expect( query ).to  match /app/
      expect( query ).to  match /appid=34/
      expect( query ).to  match /timestamp=/
      expect( query ).to  match /12345$/
    end
  end

  it "should query with the proper hashkey" do
    Offer.config_params( "abcd")
    hashkey = Offer.calculate_hash_key()
    Offer.collection_path( Offer.params ).tap do |url|
      expect(url).to match /hashkey=#{hashkey}/
    end
  end

  it "should query with given uid, pub0 and page" do
    Offer.config_params( "abcd", "uid" => 23, "pub0" => 24, "page" => 25 )
    Offer.collection_path( Offer.params ).tap do |url|
      expect(url).to match /uid=23/
      expect(url).to match /pub0=24/
      expect(url).to match /page=25/
    end
  end

  it "should handle errors when bad request" do
    Offer.config_params( "abcd", "uid" => 23, "pub0" => 24, "page" => 25 )
    expect( Offer.search()["code"] ).to eq "ERROR_INVALID_APPID"
  end

end


describe "Frontend" do
  it "should return the home page" do
    get "/"
    last_response.should be_ok
  end
end

describe 'API response' do
  it "should return a list of ads" do # the first test
    expect(Offer).to receive(:config_params)
    expect(Offer).to receive(:search)
    post '/offers' , "uid" => 23, "pub0" => 24, "page" => 25
  end
end


