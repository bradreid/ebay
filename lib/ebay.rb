module Ebay

  def self.root
    spec = Gem::Specification.find_by_name("ebay")
    spec.gem_dir
  end

  if defined?(RAILS_ENV)
    EBAY_CONFIG = YAML.load(File.read("#{RAILS_ROOT}/config/ebay.yml"))[RAILS_ENV]
  elsif defined?(Rails)
    EBAY_CONFIG = YAML.load(File.read(Rails.root.join("/config/ebay.yml")))[Rails.env]
  else
    EBAY_CONFIG = YAML.load(File.read("config/ebay.yml"))
  end


  class Request
    attr_accessor :response, :request

    def get(body, headers, service = Ebay::EBAY_CONFIG['eBay']['endpoint'])
      headers.merge!({'X-EBAY-API-APP-ID'  =>      Ebay::EBAY_CONFIG['eBay']['AppID'],
                      'X-EBAY-API-VERSION' =>      745,
                      'X-EBAY-API-SITE-ID' =>      0,
                      'Content-Type'       =>      'text/xml'
      })
      body = "<?xml version='1.0' encoding='utf-8'?>" + body
      @request = body
      @response = RestClient.post service, body, headers
      doc
    end

    def doc
      NokoSabi.new(Nokogiri::XML(@response))
    end
  end
end

Dir[File.dirname(__FILE__) + "/../lib/ebay/*.rb"].each {|f| require f}
