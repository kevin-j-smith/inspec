module Inspec::Plugin::V2::PluginType
  class Reporter < Inspec::Plugin::V2::PluginBase
    register_plugin_type(:reporter)

    #====================================================================#
    #                         Reporter  plugin type API
    #====================================================================#
    # Implementation classes must implement these methods.

    # Handle output
    # @param String output string
    # @param Boolean determines if output is expected to end with a newline
    def output(_str, _newline = true)
      raise NotImplementedError, "Plugin #{plugin_name} must implement the #output method"
    end

    # Obtain the output in the reporter
    # Return all of the output contained in the reporter
    # @return Object
    def rendered_output
      raise NotImplementedError, "Plugin #{plugin_name} must implement the #renedered_output method"
    end

    # Indicates the reporter should complete its report.
    def render
      raise NotImplementedError, "Plugin #{plugin_name} must implement the #render method"
    end
  end
end
