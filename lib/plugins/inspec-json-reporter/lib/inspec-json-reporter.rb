# frozen_string_literal: true

module InspecPlugins
  module JsonReporter
    # Entry point for Inspec Reporter plugins
    class Plugin < Inspec.plugin(2)
      plugin_name :'inspec-json-reporter'

      reporter :json do
        require_relative 'inspec-json-reporter/reporter'
        InspecPlugins::JsonReporter::Reporter
      end
    end
  end
end
