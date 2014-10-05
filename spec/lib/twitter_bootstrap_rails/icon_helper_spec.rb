# encoding: utf-8
require 'spec_helper'
require 'action_view'
require 'active_support'
require_relative '../../../app/helpers/icon_helper'

include ActionView::Helpers
include ActionView::Context
include IconHelper

describe IconHelper, :type => :helper do
  it "should return a basic fontawesome icon" do
    expect(icon(:refresh).gsub(/\s/, '').downcase)
    .to eql(BASIC_ICON.gsub(/\s/, '').downcase)
  end

  it "should return a fontawesome icon with span" do
    expect(icon(:refresh, {:tag => :span}).gsub(/\s/, '').downcase)
    .to eql(ICON_WITH_SPAN.gsub(/\s/, '').downcase)
  end
end

BASIC_ICON = %{<iclass=\"fafa-refresh\"></i>}
ICON_WITH_SPAN = %{<spanclass=\"fafa-refresh\"></span>}
