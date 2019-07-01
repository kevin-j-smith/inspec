require 'forwardable'
require 'singleton'
require 'inspec/config'
require 'inspec/exceptions'
require 'inspec/plugin/v2'

module Inspec
  # The ReporterRegistry's responsibilities include:
  #   - maintaining a list of Reproter objects that are called to report results
  class ReporterRegistry
    include Singleton
    extend Forwardable

    @@reporters = {}

    def initialize
      # Upon creation, activate all reporter plugins
      activators = Inspec::Plugin::V2::Registry.instance.find_activators(plugin_type: :reporter)

      @plugins = activators.select do |activator|
        @@reporters.key?(activator.plugin_name)
      end.map do |activator|
        reporter_configuration_options = @@reporters[activator.plugin_name]
        activator.activate!
        activator.implementation_class.new reporter_configuration_options
      end
    end

    #-------------------------------------------------------------#
    #                 Support for Regsitering Reporters
    #-------------------------------------------------------------#

    def self.register_reporter(reporter_name, options = {})
      # create the reporter
      @@reporters[reporter_name.to_sym] = options
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

    def report(_run_data)
      @plugins.each { |plugin| plugin.report(@run_data) }
    end

    #-------------------------------------------------------------#
    #               Other Support
    #-------------------------------------------------------------#

    # Used in testing
    def __reset
      @inputs_by_profile = {}
      @profile_aliases = {}
    end

    # These class methods are convenience methods so you don't always
    # have to call #instance when calling the registry
    %i[
      render_output
      report
    ].each do |meth|
      define_singleton_method(meth) do |*args|
        instance.send(meth, *args)
      end
    end
  end
end
