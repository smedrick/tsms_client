require 'spec_helper'

describe TSMS, "version" do
  it "should exist" do
    TSMS::VERSION.should be_an_instance_of(String)
  end
end