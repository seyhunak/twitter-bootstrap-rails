require 'spec_helper'
require 'action_view'
require 'active_support'
require_relative '../../../app/helpers/navbar_helper'

include ActionView::Helpers
include ActionView::Context
include NavbarHelper

describe NavbarHelper, 'uri_state', type: :helper do
  before do
    subject.stub_chain("request.host_with_port").and_return("#{HOST}")
    subject.stub_chain("request.protocol").and_return("http://")
    subject.stub_chain("request.url").and_return("#{HOST}/a/b")
    subject.stub_chain("request.path").and_return('/a/b')    
  end

  it 'must return active state' do
    subject.uri_state('/a/b').should == :active
    subject.uri_state("#{HOST}/a/b").should == :active
  end

  it 'must not return chosen for non get method' do
    subject.uri_state('/a/b', :method => 'delete').should == :inactive
    subject.uri_state("#{HOST}/a/b", :method => 'delete').should == :inactive
    subject.uri_state('/a/b', "data-method" => 'delete').should == :inactive
    subject.uri_state("#{HOST}/a/b", "data-method" => 'delete').should == :inactive
  end

  it 'must return chosen state' do
    subject.uri_state('/a').should == :chosen
    subject.uri_state("#{HOST}/a").should == :chosen
  end

  it 'must return inactive state' do
    subject.uri_state('/test').should == :inactive
    subject.uri_state("#{HOST}/test").should == :inactive
  end

  it 'must not return chosen for root url' do
    subject.uri_state('/').should == :inactive
    subject.uri_state("#{HOST}/").should == :inactive
  end

end

HOST = "http://example.com:80"
