require 'spec_helper'

describe Ebay do
  describe '.config_path' do
    context 'with Rails' do
      it 'should use rails root to find the config file' do
        Rails = mock root: Pathname.new('/tmp')
        Ebay.config_path.should == '/tmp/config/ebay.yml'
        Object.send(:remove_const, :Rails)
      end
    end
    context 'without Rails' do
      it 'should use the config file in the gem directory' do
        Ebay.should_receive(:root).and_return Pathname.new('/tmp')
        Ebay.config_path.should == '/tmp/config/ebay.yml'
      end
    end
  end

  describe '.config' do
    context 'with Rails' do
      before(:each) do
        Rails = mock root: Pathname.new(Ebay.root.join('spec/data/with_rails')), env: 'test'
        @config = Ebay.config
      end
      after(:each) do
        Object.send(:remove_const, :Rails)
      end
      it 'should define an endpoint' do
        @config['endpoint'].should == 'http://open.api.ebay.com/shopping'
      end
      it 'should define ebay creds' do
        @config['DEVID'].should == 'test_dev_id'
        @config['AppID'].should == 'test_app_id'
        @config['CertID'].should == 'test_cert_id'
      end
    end
  end
  context 'without Rails' do
    before(:each) do
      path = Ebay.root.join('spec/data/without_rails').to_s
      Ebay.should_receive(:root).and_return Pathname.new(path)
      @config = Ebay.config
    end
    it 'should define an endpoint' do
      @config['endpoint'].should == 'http://open.api.ebay.com/shopping'
    end
    it 'should define ebay creds' do
      @config['DEVID'].should == 'test_dev_id'
      @config['AppID'].should == 'test_app_id'
      @config['CertID'].should == 'test_cert_id'
    end
  end
end

