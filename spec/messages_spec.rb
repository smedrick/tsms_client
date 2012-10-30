require 'spec_helper'

describe TSMS::Messages do
  context "creating a new messages list" do
    let(:client) do
      double('client')
    end
    before do
      @messages = TSMS::Messages.new(client, '/messages')
    end
    it 'should GET itself' do
      body = [{:short_body => 'hi ho', :created_at => 'a while ago'}, {:short_body => 'feel me flow', :created_at => 'longer ago'}]
      @messages.client.should_receive(:get).and_return(double('response', :body => body, :status => 200))

      @messages.get
      @messages.collection.length.should == 2
    end
  end
end
