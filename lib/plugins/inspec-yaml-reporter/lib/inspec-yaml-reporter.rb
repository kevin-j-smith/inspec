# frozen_string_literal: true

module InspecPlugins
  module YamlReporter
    # Entry point for Inspec Reporter plugins
    class Plugin < Inspec.plugin(2)
      plugin_name :'inspec-yaml-reporter'

      reporter :json do
        require_relative 'inspec-yaml-reporter/reporter'
        InspecPlugins::YamlReporter::Reporter
      end
    end
  end
end
