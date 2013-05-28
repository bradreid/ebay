require 'spec_helper'

describe Ebay::Shopping do
  context '#eBayTime' do
    it 'should return ebay time' do
      FakeWeb.register_uri(:post,  'http://open.api.ebay.com/shopping', body: Ebay.root.join('spec/data/ebay_time_success.xml'))
      Ebay::Shopping.new.eBayTime.should == DateTime.parse('2013-05-28T17:51:25.829Z')
    end
  end
end
