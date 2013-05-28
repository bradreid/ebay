require 'yaml'
require 'rest_client'

module Ebay

  class Request
    attr_accessor :response, :request

    def get(body, headers, service = Ebay.config['endpoint'])
      headers.merge!({'X-EBAY-API-APP-ID'  =>      Ebay.config['AppID'],
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

  def self.root
    spec = Gem::Specification.find_by_name("ebay")
    Pathname.new spec.gem_dir
  end

  def self.config
    config = YAML.load_file config_path
    defined?(Rails) ? config[Rails.env] : config
  end

  def self.config_path
    start = defined?(Rails) ? Rails : self
    start.root.join('config/ebay.yml').to_s
  end
end

Dir[File.dirname(__FILE__) + "/../lib/ebay/*.rb"].each {|f| require f}
