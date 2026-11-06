# encoding: utf-8
require 'spec_helper'
require_relative '../../../app/helpers/flash_block_helper'

include ActionView::Helpers
include ActionView::Context
include FlashBlockHelper

describe FlashBlockHelper, :type => :helper do
  it "maps Rails flash keys onto Bootstrap's alert colours" do
    allow(self).to receive(:flash) { { :notice => "Saved", :alert => "Nope" } }

    expect(flash_block).to have_tag("div.alert.alert-success.alert-dismissible.fade.show", :text => "Saved")
    expect(flash_block).to have_tag("div.alert.alert-danger", :text => "Nope")
  end

  it "renders a Bootstrap 5 close button" do
    expect(flash_container(:info, "Hi")).to have_tag(:button, :with => {
      :class => "btn-close", :type => "button", "data-bs-dismiss" => "alert", "aria-label" => "Close"
    })
  end

  it "escapes unsafe messages" do
    expect(flash_container(:info, "<script>alert(1)</script>")).not_to include("<script>")
  end
end
