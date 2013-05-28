require 'spec_helper'

describe Ebay::Finding do
  before(:each) do
    @ebay = Ebay::Finding.new
  end

  context '#get_item_status' do
    it 'should not blow up when the request fails' do
      FakeWeb.register_uri(:post,  'http://open.api.ebay.com/shopping', body: Ebay.root.join('spec/data/get_item_status_failed.xml'))
      @ebay.get_item_status(10).should == :failure
    end
  end
end
