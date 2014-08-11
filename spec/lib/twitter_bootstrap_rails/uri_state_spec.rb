require 'spec_helper'
require 'action_view'
require 'active_support'
require_relative '../../../app/helpers/navbar_helper'

include ActionView::Helpers
include ActionView::Context
include NavbarHelper

describe NavbarHelper, 'uri_state', type: :helper do
  before do
    allow(subject).to receive_message_chain("request.host_with_port").and_return("#{HOST}")
    allow(subject).to receive_message_chain("request.protocol").and_return("http://")
    allow(subject).to receive_message_chain("request.url").and_return("#{HOST}/a/b")
    allow(subject).to receive_message_chain("request.path").and_return('/a/b')    
  end

  it 'must return active state' do
    expect(subject.uri_state('/a/b'))
      .to be :active
    expect(subject.uri_state("#{HOST}/a/b"))
      .to be :active
  end

  it 'must not return chosen for non get method' do
    expect(subject.uri_state('/a/b', :method => 'delete')).to be :inactive
    expect(subject.uri_state("#{HOST}/a/b", :method => 'delete')).to be :inactive
    expect(subject.uri_state('/a/b', "data-method" => 'delete')).to be :inactive
    expect(subject.uri_state("#{HOST}/a/b", "data-method" => 'delete')).to be :inactive
  end

  it 'must return chosen state' do
    expect(subject.uri_state('/a')).to be :chosen
    expect(subject.uri_state("#{HOST}/a")).to be :chosen
  end

  it 'must return inactive state' do
    expect(subject.uri_state('/test')).to be :inactive
    expect(subject.uri_state("#{HOST}/test")).to be :inactive
  end

  it 'must not return chosen for root url' do
    expect(subject.uri_state('/')).to be :inactive
    expect(subject.uri_state("#{HOST}/")).to be :inactive
  end

end

HOST = "http://example.com:80"
