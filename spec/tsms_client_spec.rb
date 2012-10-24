require 'spec_helper'

describe TsmsClient, "version" do
  it "should exist" do
    TsmsClient::VERSION.should be_an_instance_of(String)
  end
end