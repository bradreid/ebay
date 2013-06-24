require 'spec_helper'

describe Ebay::Finding do
  before(:each) do
    @ebay = Ebay::Finding.new
  end

  context '#find_items_by_category' do
    it 'should return a list of items' do
      FakeWeb.register_uri(:post,  'http://svcs.ebay.com/services/search/FindingService/v1?', body: Ebay.root.join('spec/data/ebay_find_items_by_category.xml'))
      result = @ebay.find_items_by_category
      result.map(&:itemId).should == ["221244024846", "261229157049"]
    end
  end

  context '#get_item_status' do
    it 'should not blow up when the request fails' do
      FakeWeb.register_uri(:post,  'http://open.api.ebay.com/shopping', body: Ebay.root.join('spec/data/get_item_status_failed.xml'))
      @ebay.get_item_status(10).should == :failure
    end
  end
end
