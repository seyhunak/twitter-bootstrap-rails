require 'spec_helper'

describe Twitter::Bootstrap::Breadcrumbs do
  class TestModel
    include ActiveModel::Model

    def to_s
      "test_model"
    end
  end

  class BaseTestController < AbstractController::Base
    include Twitter::Bootstrap::Breadcrumbs
    include AbstractController::Callbacks
    include AbstractController::UrlFor

    add_breadcrumb 'base', '/base'
    add_breadcrumb :base_i18n, '/base_i18n'

    def breadcrumbs
      @breadcrumbs
    end
  end

  class TestController < BaseTestController
    add_breadcrumb 'class', '/class'
    add_breadcrumb :class_i18n, '/class_i18n'

    def show
      add_breadcrumb 'instance', '/instance'
      add_breadcrumb :instance_i18n, '/instance_i18n'

      test_model = TestModel.new
      add_breadcrumb test_model

      add_breadcrumb :symbolized
      add_breadcrumb :show
    end

    def symbolized_path
      '/symbolized'
    end

    def test_models_path
      '/test_model'
    end
  end

  before do
    options = { :scope => [:breadcrumbs, 'test'] }
    [:class_i18n, :instance_i18n, :show, :symbolized].each do |name|
      I18n.expects(:t).with(name, options).returns(name.to_s)
    end

    name = :base_i18n
    options = { :scope => [:breadcrumbs, 'base_test'] }
    I18n.expects(:t).with(name, options).returns(name)

    @controller = TestController.new
    @controller.process(:show)
  end

  it "have breadcrumbs" do
    [:base, :base_i18n, :class, :class_i18n, :instance, :instance_i18n, :test_model, :symbolized].each do |name|
      path = "/#{name}"
      idx = @controller.breadcrumbs.index { |b| b[:name] == name.to_s && b[:url] == path }
      idx.should be, -> { name }
    end

    idx = @controller.breadcrumbs.index { |b| b[:name] == "show" && b[:url] == '' }
    idx.should be
  end

end
