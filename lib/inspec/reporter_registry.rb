# frozen_string_literal: true

require "forwardable"
require "singleton"
require "inspec/config"
require "inspec/exceptions"
require "inspec/plugin/v2"

require "yaml"

module Inspec
  # The ReporterRegistry"s responsibilities include:
  #   - maintaining a list of Reproter objects that are called to report results
  class ReporterRegistry
    include Singleton
    extend Forwardable

    #-------------------------------------------------------------#
    #                 Support for Regsitering Reporters
    #-------------------------------------------------------------#
    @@reporters = {}

    def self.register_reporter(reporter_name, options = {})
      # create the reporter
      @@reporters[reporter_name.to_sym] = options
    end

    def initialize
      # Upon creation, activate all reporter plugins
      activators = Inspec::Plugin::V2::Registry.instance.find_activators(plugin_type: :reporter) # rubocop:disable Metrics/LineLength

      @plugins = activators.select do |activator|
        @@reporters.key?(activator.plugin_name)
      end
      @plugins = @plugins.map do |activator|
        activator.activate!
        activator.implementation_class.new @@reporters[activator.plugin_name]
      end
    end

    #-------------------------------------------------------------#
    #              Support for Finializing Profile Run
    #-------------------------------------------------------------#

    def render_output(run_data)
      @plugins.each do |plugin|
        plugin.run_data = run_data
        plugin.render
      end
    end

    def report(run_data)
      @plugins.each { |plugin| plugin.report(run_data) }
    end

    #-------------------------------------------------------------#
    #               Other Support
    #-------------------------------------------------------------#

    def self.all_reporting_to_stdout?
      @@reporters.each do |reporter, config|
        return false unless config["stdout"] == true
      end
      true
    end

    # Used in testing
    def __reset
      @inputs_by_profile = {}
      @profile_aliases = {}
    end

    # These class methods are convenience methods so you don"t always
    # have to call #instance when calling the registry
    %i{
      render_output
      rendered_output
      report
    }.each do |meth|
      define_singleton_method(meth) do |*args|
        instance.send(meth, *args)
      end
    end
  end
end
