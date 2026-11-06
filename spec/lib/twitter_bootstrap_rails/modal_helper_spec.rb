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
		expect(close_button('modal')).to eql CLOSE_BUTTON
	end

  it 'dismisses the modal when no dismiss target is given' do
    expect(close_button(nil)).to eql CLOSE_BUTTON
  end

  it 'escapes the dismiss target' do
    expect(close_button('"><script>')).not_to include('<script>')
  end

  it 'applies the requested size to the dialog' do
    expect(modal_dialog(options.merge(:size => 'modal-lg'))).to have_tag('div.modal-dialog.modal-lg')
  end

  it 'renders a modal toggle button' do
    expect(modal_toggle('Save', :href => "#modal").gsub(/\n/, "")).to eql MODAL_TOGGLE.gsub(/\n/, "")
  end

  it 'renders a cancel button' do
    expect(modal_cancel_button("Cancel", :href => "#modal").gsub(/\n/, "")).to eql MODAL_CANCEL_BUTTON.gsub(/\n/, "")
  end
end

CLOSE_BUTTON = %q{<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>}

BASIC_MODAL = <<-HTML
<div class="bootstrap-modal modal fade" id="modal" tabindex="-1" aria-hidden="true"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><h5 class="modal-title">Modal header</h5><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button></div><div class="modal-body">This is the body</div><div class="modal-footer"><button class="btn">Save</button></div></div></div></div>
HTML

MODAL_HEADER_WITHOUT_CLOSE = <<-HTML
<div class="modal-header"><h5 class="modal-title">Modal header</h5></div>
HTML

MODAL_HEADER_WITH_CLOSE = <<-HTML
<div class="modal-header"><h5 class="modal-title">Modal header</h5><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button></div>
HTML

MODAL_TOGGLE = <<-HTML
<a class="btn btn-secondary" data-bs-toggle="modal" href="#modal">Save</a>
HTML

MODAL_CANCEL_BUTTON = <<-HTML
<a class="btn btn-secondary bootstrap-modal-cancel-button" data-bs-dismiss="modal" href="#modal">Cancel</a>
HTML
