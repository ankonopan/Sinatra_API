require 'digest/sha1'


# Using ActiveResource for querying the API
# There is no particular intention on this decicion but to have a proper offer class with more functionalities

class Offer < ActiveResource::Base
  add_response_method :http_response
  self.site = "http://api.sponsorpay.com/feed/v1"
  @@params = {
      "format" => "json",
      "locale" => "de",
      "offer_types" => 112,
      "timestamp" => Time.now.to_time.to_i,
      "apple_idfa" =>"",
      "apple_idfa_tracking_enabled" => true
    }
  @@api_key = ""

  def self.config_params( key, params = {} )
    @@api_key = key
    @@params = @@params.merge params
  end

  def self.params
    @@params.merge( hashkey: calculate_hash_key() )
  end

  def self.calculate_hash_query()
    @@params.sort{|a,b| a[0]<=>b[0]}.map{ |pair| pair.join("=") }.join("&") << "&#{@@api_key}"
  end

  def self.calculate_hash_key()
    Digest::SHA1.hexdigest calculate_hash_query()
  end


  def self.search()
    begin
      Offer.all( params: Offer.params )
    rescue Exception => e
      JSON.parse(Offer.connection.http_response.body).select{|key,value| ["code", "message"].include?(key) }
    end
  end

end