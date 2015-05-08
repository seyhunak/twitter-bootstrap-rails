# encoding: utf-8
require 'spec_helper'
require_relative '../../../app/helpers/modal_helper'

include ActionView::Helpers
include ActionView::Context
include ModalHelper

describe ModalHelper, :type => :helper do
  header_with_close    = { :show_close => true, :dismiss => 'modal', :title => 'Modal header' }
  header_without_close = { :show_close => false, :title => 'Modal header' }
  options              = { :id => "modal",
												 	 :header => header_with_close,
                           :body   => { content: 'This is the body' },
                           :footer => { content: content_tag(:button, 'Save', :class => 'btn') }
  }

  it 'returns a complete modal' do
    expect(modal_dialog(options).gsub(/\n/, "")).to eql BASIC_MODAL.gsub(/\n/, "")
  end

  it 'returns a modal header with a close button if show_close is true' do
    expect(modal_header(header_with_close).gsub(/\n/, "")).to eql MODAL_HEADER_WITH_CLOSE.gsub(/\n/, "")
  end

  it 'renders a modal header without a close button' do
    expect(modal_header(header_without_close).gsub(/\n/, "")).to eql MODAL_HEADER_WITHOUT_CLOSE.gsub(/\n/, "")
  end

	it 'renders a close button' do
		expect(close_button('modal')).to eql "<button class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">&times;</button>"
	end

  it 'renders a modal toggle button' do
    expect(modal_toggle('Save', :href => "#modal").gsub(/\n/, "")).to eql MODAL_TOGGLE.gsub(/\n/, "")
  end

  it 'renders a cancel button' do
    expect(modal_cancel_button("Cancel", :data => {:dismiss => 'modal'}, :href => "#modal").gsub(/\n/, "")).to eql MODAL_CANCEL_BUTTON.gsub(/\n/, "")
  end
end

BASIC_MODAL = <<-HTML
<div class=\"bootstrap-modal modal fade\" id=\"modal\"><div class=\"modal-dialog \"><div class=\"modal-content\"><div class=\"modal-header\"><button class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">&times;</button><h4 class=\"modal-title\">Modal header</h4></div><div class=\"modal-body\">This is the body</div><div class=\"modal-footer\"><button class="btn">Save</button></div></div></div></div>
HTML

MODAL_HEADER_WITHOUT_CLOSE = <<-HTML
<div class="modal-header"><h4 class=\"modal-title\">Modal header</h4></div>
HTML

MODAL_HEADER_WITH_CLOSE = <<-HTML
<div class="modal-header"><button class="close" data-dismiss="modal" aria-hidden=\"true\">&times;</button><h4 class=\"modal-title\">Modal header</h4></div>
HTML

MODAL_TOGGLE = <<-HTML
<a class="btn btn-default" data-toggle="modal" href="#modal">Save</a>
HTML

MODAL_CANCEL_BUTTON = <<-HTML
<a class="btn bootstrap-modal-cancel-button" data-dismiss="modal" href="#modal">Cancel</a>
HTML

