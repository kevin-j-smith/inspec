require 'inspec/config'

module Inspec::Plugin::V2::PluginType
  class Reporter < Inspec::Plugin::V2::PluginBase
    register_plugin_type(:reporter)

    #====================================================================#
    #                         Reporter  plugin type API
    #====================================================================#
    # Implementation classes must implement these methods.
    def initialize(config)
      @config = config
      @output = ''
    end

    attr_reader :config

    # Append output
    # @param String output string
    # @param Boolean determines if output is expected to end with a newline
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
    def render
      if config['file']
        # create destination directory if it does not exist
        dirname = File.dirname(config['file'])
        FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

        File.write(config['file'], @output)
      end
      if config['stdout'] == true
        print @output
        $stdout.flush
      end
      @output = ''
    end

    attr_writer :run_data
  end
end
