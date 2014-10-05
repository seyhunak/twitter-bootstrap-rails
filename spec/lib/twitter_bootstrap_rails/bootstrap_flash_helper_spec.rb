# encoding: utf-8
require 'spec_helper'
require_relative '../../../app/helpers/bootstrap_flash_helper'

include ActionView::Helpers
#include ActionView::Context
include BootstrapFlashHelper

describe BootstrapFlashHelper, :type => :helper do
  describe "bootstrap_flash" do
    let(:flash) { ActionDispatch::Flash::FlashHash.new }
    before { allow(self).to receive(:flash).and_return flash }

    context "when type is :notice" do   
      before { flash[:notice] = "success flash" }

      it "should return a success flash message" do
        expect(bootstrap_flash.gsub(/\s/, '').downcase)
          .to eql(BASIC_SUCCESS_FLASH.gsub(/\s/, '').downcase)
      end
    end

    context "when type is :alert" do
      before { flash[:alert] = "danger flash" }

      it "should return a danger flash message" do
        expect(bootstrap_flash.gsub(/\s/, '').downcase)
          .to eql(BASIC_DANGER_FLASH.gsub(/\s/, '').downcase)
      end
    end

    context "when type is :error" do
      before { flash[:error] = "danger flash" }

      it "should return a danger flash message" do
        expect(bootstrap_flash.gsub(/\s/, '').downcase)
          .to eql(BASIC_DANGER_FLASH.gsub(/\s/, '').downcase)
      end
    end

    context "when class is set" do
      before { flash[:notice] = "success flash" }

      it "should display the class" do
        expect(bootstrap_flash({class: 'success-class'}).gsub(/\s/, '').downcase)
          .to eql(BASIC_SUCCESS_FLASH_WITH_CLASS.gsub(/\s/, '').downcase)
      end
    end
    
  end
end

BASIC_DANGER_FLASH = <<-HTML
<div class="alert fade in alert-danger">
  <button class="close" data-dismiss="alert" type="button">&times;</button>danger flash
</div>
HTML

BASIC_SUCCESS_FLASH = <<-HTML
<div class="alert fade in alert-success">
  <button class="close" data-dismiss="alert" type="button">&times;</button>success flash
</div>
HTML

BASIC_SUCCESS_FLASH_WITH_CLASS = <<-HTML
<div class="alert fade in alert-success success-class">
  <button class="close" data-dismiss="alert" type="button">&times;</button>success flash
</div>
HTML