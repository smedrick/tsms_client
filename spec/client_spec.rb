require 'spec_helper'
describe TSMS::Client do
  context "creating a new client" do
    before do
      response = double('response', :body => {"_links" => [{"self" => "/"}, {"horse" => "/horses/new"}, {"rabbits" => "/rabbits"}]})
      raw_connection = double('raw_connection', :get => response)
      TSMS::Connection.stub(:new).and_return(double('connection', :connection => raw_connection))
      @client = TSMS::Client.new('username', 'password', 'null_url')
    end
    it 'should discover endpoints for known services' do
      @client.horse.should be_kind_of(TSMS::Horse)
      @client.rabbits.should be_kind_of(TSMS::Rabbits)
    end
  end


end
