require "forwardable"
require "singleton"
require "inspec/exceptions"
require "inspec/plugin/v2"

require 'yaml'

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

      @plugins = activators.map do |activator|
        # TODO: only activate those reporters that have been registered
        activator.activate!
        activator.implementation_class.new
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
    #                 Support for Submitting Results
    #-------------------------------------------------------------#

    #def append_result(control, result)
    def output(str, newline = true)
      #@plugins.map { |plugin| plugin.append_result(control, result) }
      puts "HELLO\n#{@plugins.to_yaml}\nWORLD\n#{@@reporters.to_yaml}\n"
      @plugins.map { |plugin| plugin.output(str, newline) }
    end

    #-------------------------------------------------------------#
    #              Support for Finializing Profile Run
    #-------------------------------------------------------------#

    def rendered_output
      @plugins.map { |plugin| plugin.rendered_output }
    end

    #-------------------------------------------------------------#
    #              Support for Finializing Profile Run
    #-------------------------------------------------------------#

    def render
      @plugins.map { |plugin| plugin.render }
    end

    def report(run_data)
      puts "ReporterRegistry.report: #{run_data.to_yaml}"
    end

    #-------------------------------------------------------------#
    #               Other Support
    #-------------------------------------------------------------#
    public

    # Used in testing
    def __reset
      @inputs_by_profile = {}
      @profile_aliases = {}
    end

    # These class methods are convenience methods so you don't always
    # have to call #instance when calling the registry
    [
      :list_reporters,
      :output,
      :rendered_output,
      :render,
      :report
    ].each do |meth|
      define_singleton_method(meth) do |*args|
        instance.send(meth, *args)
      end
    end
  end
end
