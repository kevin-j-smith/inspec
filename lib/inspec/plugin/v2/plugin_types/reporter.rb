require "inspec/config"
require "inspec/plugin/v2/registry"

module Inspec
  module Plugin
    module V2
      module PluginType
        # Inspec Plugin Type for Reporters.  All reporter plugins
        #   can use these methods for working with Inspec
        class Reporter < Inspec::Plugin::V2::PluginBase
          register_plugin_type(:reporter)

          #====================================================================#
          #                         Reporter  plugin type API
          #====================================================================#
          # Implementation classes must implement these methods.
          def initialize(config)
            @config = config
            @output = ""
            # rubocop:disable Metrics/LineLength
            register_child_reporter(config["child_reporter"].to_sym, { "stdout" => false }) if config.include? "child_reporter"
            # rubocop:enable Metrics/LineLength
            @run_data = {}
          end

          attr_reader :config, :child_reporter
          attr_writer :run_data

          # Append output
          # @param String output string
          # @param Boolean determines if output is expected to
          #   end with a newline
          def output(str, newline = true)
            @output << str
            @output << "\n" if newline
          end

          # Obtain the output in the reporter
          # Return all of the output contained in the reporter
          # @return Object
          def rendered_output
            @output
          end

          # Indicates the reporter should complete its report.
          def render # rubocop:disable Metrics/AbcSize
            if config["file"]
              # create destination directory if it does not exist
              dirname = File.dirname(config["file"])
              FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

              File.write(config["file"], @output)
            end
            if config["stdout"] == true
              print @output
              $stdout.flush
            end
          end

          protected

          def register_child_reporter(plugin_name, config)
            # rubocop:disable Metrics/LineLength
            @child_reporter = Inspec::Plugin::V2::Registry.instance.find_activator(plugin_name: plugin_name)
            # rubocop:enable Metrics/LineLength
            @child_reporter.activate!
            @child_reporter = @child_reporter.implementation_class.new config
          end
        end
      end
    end
  end
end
