require 'spec_helper'

describe TSMS::Message do
  context "creating a new message" do
    let(:client) do
      c = double('client')
      links = [{"self" => nil}, {"rabbits" => nil}]
      c.stub('get').and_return({"_links" => links, :body=>nil})
      c
    end
    before do

    end
    it ' should create appropriate accessors ' do
      m = TSMS::Message.new(client, '/stub')
      m.body.should be_nil
    end
  end


end
