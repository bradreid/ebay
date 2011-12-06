# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ebay/version"

Gem::Specification.new do |s|
  s.name        = "ebay"
  s.version     = Ebay::VERSION
  s.authors     = ["Brad Reid"]
  s.email       = ["brad@beyondthecube.ca"]
  s.homepage    = ""
  s.summary     = %q{Implements parts of the ebay api}
  s.description = %q{Implements parts of the ebay api}

  s.rubyforge_project = "ebay"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", 'lib/ebay']
  
  s.add_dependency 'rest-client'  
  s.add_dependency 'nokogiri'
end
