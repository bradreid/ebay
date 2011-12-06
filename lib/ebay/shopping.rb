module Ebay
  class Shopping < Request
    def eBayTime
      body = "<GeteBayTimeRequest xmlns='urn:ebay:apis:eBLBaseComponents'></GeteBayTimeRequest>"
      headers = {'X-EBAY-API-CALL-NAME' => 'GeteBayTime', 'X-EBAY-API-REQUEST-ENCODING' => 'XML'}
      t = self.get(body, headers)
      Time.parse(t.Timestamp)
    end
  end
end