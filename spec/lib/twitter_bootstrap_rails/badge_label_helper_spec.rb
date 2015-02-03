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
    expect(badge('New!').gsub(/\s/, '').downcase)
      .to eql(BASIC_BADGE.gsub(/\s/, '').downcase)
  end

  it "should return a bootstrap badge with class" do
    expect(badge('2', :warning).gsub(/\s/, '').downcase)
      .to eql(BADGE_WITH_CLASS.gsub(/\s/, '').downcase)
  end

  it "should take a Number as its first parameter" do
  	expect(badge(12).gsub(/\s/, '').downcase)
  	.to eql(BADGE_WITH_NUMBER_PARAM.gsub(/\s/, '').downcase)
  end
end

BASIC_BADGE = %{<span class="badge">New!</span>}
BADGE_WITH_CLASS = %{<span class="badge badge-warning">2</span>}
BADGE_WITH_NUMBER_PARAM = %{<span class="badge">12</span>}