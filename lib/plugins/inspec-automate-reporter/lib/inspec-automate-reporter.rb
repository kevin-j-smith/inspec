# frozen_string_literal: true

module InspecPlugins
  module AutomateReporter
    # Entry point for Inspec Reporter plugins
    class Plugin < Inspec.plugin(2)
      plugin_name :'inspec-automate-reporter'

      reporter :automate do
        require_relative 'inspec-automate-reporter/reporter'
        InspecPlugins::AutomateReporter::Reporter
      end
    end
  end
end
