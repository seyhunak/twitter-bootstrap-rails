# encoding: utf-8
require 'spec_helper'
require 'action_view'
require 'active_support'
require_relative '../../../app/helpers/badge_label_helper'

include ActionView::Helpers
include ActionView::Context
include BadgeLabelHelper

describe BadgeLabelHelper, :type => :helper do
  it "should return a basic bootstrap badge" do
    badge('test').gsub(/\s/, '').downcase.should eql(BASIC_BADGE.gsub(/\s/, '').downcase)
  end

  it "should return a bootstrap badge with class" do
    badge('waning', :warning).gsub(/\s/, '').downcase.should eql(BADGE_WITH_CLASS.gsub(/\s/, '').downcase)
  end
end

BASIC_BADGE = %{<span class="badge">test</span>}
BADGE_WITH_CLASS = %{<span class="badge badge-warning">waning</span>}
