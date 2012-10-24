require 'spec_helper'

describe TsmsClient, "version" do
  it "returns 0 for all gutter game" do
    TsmsClient::VERSION.should be_an_instance_of(String)
  end
end