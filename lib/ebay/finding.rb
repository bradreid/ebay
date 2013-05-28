require 'rest-client'
require 'nokogiri'

module Ebay
  class Finding < Request


    def get_item(item)
      body = <<-eos
                <GetSingleItemRequest xmlns="urn:ebay:apis:eBLBaseComponents">
                <ItemID>#{item}</ItemID>
                <IncludeSelector>Description</IncludeSelector>
                </GetSingleItemRequest>
      eos

      headers = {'X-EBAY-API-CALL-NAME' => 'GetSingleItem', 'X-EBAY-API-REQUEST-ENCODING' => 'XML'}
      t = self.get(body, headers)
      t.GetSingleItemResponse.Item
    end

    def get_item_status(item)
      body = <<-eos
                <GetItemStatusRequest xmlns="urn:ebay:apis:eBLBaseComponents">
                  <ItemID>#{item}</ItemID>
                </GetItemStatusRequest>
      eos

      headers = {'X-EBAY-API-CALL-NAME' => 'GetItemStatus', 'X-EBAY-API-REQUEST-ENCODING' => 'XML'}
      t = self.get(body, headers)

      return :invalid_id if t.GetItemStatusResponse.Ack == 'Failure' && t.GetItemStatusResponse.Errors.ShortMessage == 'Invalid item ID.'
      return :failure if t.GetItemStatusResponse.Ack == 'Failure'
      return t.GetItemStatusResponse.Item if t.GetItemStatusResponse.Ack == 'Success'
      nil
    end


    def find_items_by_category(category=63676)
      body = <<-eos
             <findItemsByCategoryRequest xmlns='http://www.ebay.com/marketplace/search/v1/services'>
             <categoryId>#{category}</categoryId>
             <sortOrder>EndTimeSoonest</sortOrder>
             <outputSelector>PictureURLLarge</outputSelector>
             <paginationInput>
             <pageNumber>1</pageNumber>
             <entriesPerPage>100</entriesPerPage>
             </paginationInput>
             </findItemsByCategoryRequest>
      eos

      headers = {'X-EBAY-SOA-SERVICE-NAME' => 'FindingService',
                 'X-EBAY-SOA-OPERATION-NAME' => 'findItemsByCategory',
                 'X-EBAY-SOA-SERVICE-VERSION' => '1.11.0',
                 'X-EBAY-SOA-GLOBAL-ID' => 'EBAY-US',
                 'X-EBAY-SOA-SECURITY-APPNAME' => Ebay.config['AppID'],
                 'X-EBAY-SOA-REQUEST-DATA-FORMAT' => 'XML'
      }
      r = self.get(body, headers, 'http://svcs.ebay.com/services/search/FindingService/v1?')
      @items = r.findItemsByCategoryResponse.searchResult.item
      num_pages =   r.findItemsByCategoryResponse.paginationOutput.totalPages.to_i
      (2..num_pages).each do |p|
        body = body.gsub("<pageNumber>1</pageNumber>", "<pageNumber>#{p}</pageNumber>")
        r = self.get(body, headers, 'http://svcs.ebay.com/services/search/FindingService/v1?')
        @items += r.findItemsByCategoryResponse.searchResult.item
      end
      @items
    end
  end
end
