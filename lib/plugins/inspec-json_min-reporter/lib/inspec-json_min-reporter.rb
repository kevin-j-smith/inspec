# frozen_string_literal: true

module InspecPlugins
  module JsonMinReporter
    # Entry point for Inspec Reporter plugins
    class Plugin < Inspec.plugin(2)
      plugin_name :'inspec-json_min-reporter'

      reporter :json_min do
        require_relative 'inspec-json_min-reporter/reporter'
        InspecPlugins::JsonMinReporter::Reporter
      end
    end
  end
end
