# encoding: utf-8
require 'spec_helper'
require 'action_view'
require 'active_support'
require 'rspec/active_model/mocks'

require_relative '../../../app/helpers/form_errors_helper'

include ActionView::Helpers
include ActionView::Context
include FormErrorsHelper

describe FormErrorsHelper, :type => :helper do

  before do
    @base_errors = ['base error message', 'nasty error']
    @base_error = 'one base error'


    @title_errors = ["can't be blank", 'is too short (minimum is 5 characters)']
    @title_error = "can't be blank"

    @errors = double('errors')
    @new_post =  mock_model( 'Post' )
    allow(@new_post).to receive_messages(:errors => @errors)
    allow(self).to receive_messages(:post_path => '/post/1')
    allow(self).to receive_messages(:protect_against_forgery? => false)
    allow(self).to receive_messages(:polymorphic_path => '')

    @default_class = 'help-block'
    @default_error_class = 'has-error'
  end


  describe 'error[:base] is a string' do

    before do
      allow(@errors).to receive(:[]).with(:base).and_return(@base_error)
    end

    it 'should render base error on :base key' do
      form_for(@new_post) do |builder|
        expect(builder.error_span(:base)).to have_tag("div.#{@default_error_class}") do
          with_tag("span.#{@default_class}", :text => @base_error)
        end
      end
    end

  end


  describe 'when there is only one error on base' do

    before do
      allow(@errors).to receive(:[]).with(:base).and_return(@base_error)
    end

    it 'should render base error on :base key' do
      form_for(@new_post) do |builder|
        expect(builder.error_span(:base)).to have_tag("div.#{@default_error_class}") do
          with_tag("span.#{@default_class}", :text => @base_error)
        end
      end
    end

  end

  describe 'when there is only one error on title' do

    before do
      allow(@errors).to receive(:[]).with(:title).and_return(@title_error)
    end

    it 'should render base errors join with comma' do
      form_for(@new_post) do |builder|
        expect(builder.error_span(:title)).to have_tag("div.#{@default_error_class}") do
          with_tag("span.#{@default_class}", :text => @title_error)
        end
      end
    end
  end



  describe 'when there is more than one error on title' do

    before do
      allow(@errors).to receive(:[]).with(:title).and_return(@title_errors)
    end

    it 'should render base errors join with comma' do
      form_for(@new_post) do |builder|
        expect(builder.error_span(:title)).to have_tag("div.#{@default_error_class}") do
          with_tag("span.#{@default_class}", :text => @title_errors.join(', '))
        end
      end
    end
  end


  describe 'when there are no errors' do
    before do
      allow(@errors).to receive(:[]).with(:title).and_return(nil)
    end

    it 'should return nil' do
      form_for(@new_post) do |builder|
        expect(builder.error_span(:title)).to be_nil
      end
    end
  end

  describe 'when :error_class option is passed' do
    let(:error_class) { 'has_warning' }

    before do
      allow(@errors).to receive(:[]).with(:title).and_return(@title_error)
    end

    it "should render with passed error class " do
      form_for(@new_post) do |builder|
        expect(builder.error_span(:title, :error_class => error_class))
        .to have_tag("div.#{error_class}") do
          with_tag("span.#{@default_class}", :text => @title_error)
        end
      end
    end
  end

  describe 'when :error_class option is passed' do
    let(:span_class) { 'help-inline' }

    before do
      allow(@errors).to receive(:[]).with(:title).and_return(@title_error)
    end

    it "should render with passed error class " do
      form_for(@new_post) do |builder|
        expect(builder.error_span(:title, :span_class => span_class))
        .to have_tag("div.#{@default_error_class}") do
          with_tag("span.#{span_class}", :text => @title_error)
        end
      end
    end

  end

end
