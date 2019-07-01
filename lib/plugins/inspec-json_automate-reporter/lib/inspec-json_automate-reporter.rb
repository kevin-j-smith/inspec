# frozen_string_literal: true

module InspecPlugins
  module JsonAutomateReporter
    # Entry point for Inspec Reporter plugins
    class Plugin < Inspec.plugin(2)
      plugin_name :'inspec-json_automate-reporter'

      reporter :json_automate do
        require_relative 'inspec-json_automate-reporter/reporter'
        InspecPlugins::JsonAutomateReporter::Reporter
      end
    end
  end
end
