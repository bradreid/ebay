module Ebay
  if defined?(ENV['GEM_DEVELOPMENT'])
    require 'rest-client'
    require 'nokogiri'
  end
  
  if defined?(RAILS_ENV)
    EBAY_CONFIG = YAML.load(File.read("#{RAILS_ROOT}/config/ebay.yml"))[RAILS_ENV]    
  else
    EBAY_CONFIG = YAML.load(File.read("config/ebay.yml"))
  end
  
  
  class Request
    def get(body, headers, service = Ebay::EBAY_CONFIG['eBay']['endpoint'])
      headers.merge!({'X-EBAY-API-APP-ID'  =>      Ebay::EBAY_CONFIG['eBay']['AppID'], 
                      'X-EBAY-API-VERSION' =>      745, 
                      'X-EBAY-API-SITE-ID' =>      0
                    })
      body = "<?xml version='1.0' encoding='utf-8'?>" + body
      @response = RestClient.post service, body, headers
      NokoSabi.new(Nokogiri::XML(@response))
    end
    
    def doc
      NokoSabi.new(Nokogiri::XML(@response))
    end
  end  
end

Dir[File.dirname(__FILE__) + "/../lib/ebay/*.rb"].each {|f| require f}
