# encoding: utf-8
require 'spec_helper'
require 'action_view'
require 'active_support'
require_relative '../../../app/helpers/bootstrap_flash_helper'

include ActionView::Helpers
include ActionView::Context
include BootstrapFlashHelper

describe BootstrapFlashHelper, type: :helper do
  before do
    allow(self).to receive(:uri_state) { :inactive }
    allow(self).to receive(:root_url) { '/' }
  end

  describe "bootstrap_flash" do
    it "should not return anything without flashes" do
      allow(self).to receive(:flash) { {} }

      element = bootstrap_flash

      expect(element).to eql("")
    end

    it "should work with a notice" do
      allow(self).to receive(:flash) { {notice: "Hello"} }

      element = bootstrap_flash

      expect(element).to have_tag(:div,
        text: "Hello",
        with: {class: "alert alert-success alert-dismissible fade show"}) {

        with_tag(:button, with: {class: "btn-close", "data-bs-dismiss" => "alert", type: "button", "aria-label" => "Close"})

      }
    end

    it "should work with a notice and an extra class" do
      allow(self).to receive(:flash) { {notice: "Hello"} }

      element = bootstrap_flash(class: "extra-class")

      expect(element).to have_tag(:div,
        text: "Hello",
        with: {class: "alert alert-success alert-dismissible fade show extra-class"}) {

        with_tag(:button, with: {class: "btn-close", "data-bs-dismiss" => "alert", type: "button", "aria-label" => "Close"})

      }
    end

    it "should work with a notice and an extra class and an extra attribute" do
      allow(self).to receive(:flash) { {notice: "Hello"} }

      element = bootstrap_flash(class: "extra-class", "data-no-transition-cache" => true)

      expect(element).to have_tag(:div,
        text: "Hello",
        with: {
          class: "alert alert-success alert-dismissible fade show extra-class",
          "data-no-transition-cache" => true
        }) {

        with_tag(:button, with: {class: "btn-close", "data-bs-dismiss" => "alert", type: "button", "aria-label" => "Close"})

      }
    end

    it "should escape javascript if not marked as safe by user" do
      allow(self).to receive(:flash) { {notice: "<script>alert(1)</script>"} }

      element = bootstrap_flash

      expect(element).to have_tag(:div,
                                  text: "<script>alert(1)</script>",
                                  with: {class: "alert alert-success alert-dismissible fade show"}) {
                           with_tag(:button, with: {class: "btn-close", "data-bs-dismiss" => "alert", type: "button", "aria-label" => "Close"})
                         }
    end

    it "should keep the extra class on every message" do
      allow(self).to receive(:flash) { {notice: ["One", "Two"]} }

      element = bootstrap_flash(class: "extra-class")

      expect(element).to have_tag("div.extra-class", count: 2)
    end

    it "should not escape a link if marked as safe by user" do
      allow(self).to receive(:flash) { {notice: "<a href='example.com'>awesome link!</a>".html_safe} }

      element = bootstrap_flash

      expect(element).to have_tag(:div,
                                  text: "awesome link!",
                                  with: {class: "alert alert-success alert-dismissible fade show"}) { [
                             with_tag(:button, with: {class: "btn-close", "data-bs-dismiss" => "alert", type: "button", "aria-label" => "Close"}),
                             with_tag(:a,
                                      text: 'awesome link!')
                         ]
                         }
    end
  end
end