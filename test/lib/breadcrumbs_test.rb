require "test_helper"

module AbstractController
  module Testing

    class TestHelper
      BREADCRUMB_NAMES = [:class_level, :class_level_i18n, :instance_level,
        :instance_level_i18n, :base_level, :base_level_i18n]

      class << self
        BREADCRUMB_NAMES.each do |name|
          define_method "#{name}_name" do
            "test-breadcrumb-#{name}"
          end

          define_method "#{name}_path" do
            "/test/breadcrumb/#{name}"
          end
        end
      end
    end

    class BaseTestController < AbstractController::Base
      include Twitter::Bootstrap::BreadCrumbs
      include AbstractController::Callbacks

      add_breadcrumb TestHelper.base_level_name, TestHelper.base_level_path
      add_breadcrumb :base_level_i18n, TestHelper.base_level_i18n_path

      def breadcrumbs
        @breadcrumbs
      end
    end

    class TestController < BaseTestController
      add_breadcrumb TestHelper.class_level_name, TestHelper.class_level_path
      add_breadcrumb :class_level_i18n, TestHelper.class_level_i18n_path

      def index
        add_breadcrumb TestHelper.instance_level_name, TestHelper.instance_level_path
        add_breadcrumb :instance_level_i18n, TestHelper.instance_level_i18n_path
      end
    end

    class BreadcrumbsTest < MiniTest::Unit::TestCase
      def setup
        options = { scope: [:breadcrumbs, 'abstract_controller', 'testing', 'test'] }
        [:class_level_i18n, :instance_level_i18n].each do |name|
          I18n.expects(:t).with(name, options).returns(TestHelper.send("#{name}_name"))
        end

        name = :base_level_i18n
        options = { scope: [:breadcrumbs, 'abstract_controller', 'testing', 'base_test'] }
        I18n.expects(:t).with(name, options).returns(TestHelper.send("#{name}_name"))

        @controller = TestController.new
        @controller.process(:index)
      end

      def test_should_have_breadcrumbs
        TestHelper::BREADCRUMB_NAMES.each do |name|
          assert include_breadcrumb?(name), "#{name} breadcrumb not found"
        end
      end

      def include_breadcrumb?(name)
        selected = @controller.breadcrumbs.select { |b|
          b[:name] == TestHelper.send("#{name}_name") &&
          b[:url] == TestHelper.send("#{name}_path")
        }
        selected.any?
      end
    end
  end
end
