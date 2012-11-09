require 'spec_helper'

describe TSMS::InboundMessages do
  context "creating a new inbound messages list" do
    let(:client) do
      double('client')
    end
    before do
      @messages = TSMS::InboundMessages.new(client, '/inbound_messages')
    end
    it 'should GET itself' do
      body = [{:body=>"HELP", :from=>"+16125551212", :created_at=>"a while ago", :to=>"(651) 433-6258"}, {:body=>"STOP", :from=>"+16125551212", :created_at=>"a while ago", :to=>"(651) 433-6258"}]
      @messages.client.should_receive(:get).and_return(double('response', :body => body, :status => 200, :headers => {}))

      @messages.get
      @messages.collection.length.should == 2
    end
  end
end
