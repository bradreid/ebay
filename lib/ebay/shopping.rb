module Ebay
  class Shopping < Request
    def eBayTime
      body = "<GeteBayTimeRequest xmlns='urn:ebay:apis:eBLBaseComponents'></GeteBayTimeRequest>"
      headers = {'X-EBAY-API-CALL-NAME' => 'GeteBayTime', 'X-EBAY-API-REQUEST-ENCODING' => 'XML'}
      t = self.get(body, headers)
      DateTime.parse(t.GeteBayTimeResponse.Timestamp)
    end
  end
end
