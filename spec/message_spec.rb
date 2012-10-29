require 'spec_helper'

describe TSMS::Message do
  context "creating a new message" do
    let(:client) do
      c = double('client')
      links = [{"self" => nil}, {"recipients" => nil}]

      c.stub('get').and_return({"_links" => links, 'short_body' => nil})
      c
    end
    before do

    end
    it ' should create appropriate accessors ' do
      m = TSMS::Message.new(client, '/stub')
      m.short_body.should be_nil
      m.recipients.class.should == TSMS::Recipients

      post_links = [{"self" => '/messages/52/'}, {"recipients" => '/messages/52/recipients'}]
      m.should_receive('post').and_return({"_links" => post_links, 'short_body' => '12345678'})
      (r = m.recipients.build(:phone => '16125015456').class.should) == TSMS::Recipient
      m.post
    end
  end


end
