# frozen_string_literal: true

module InspecPlugins
  module JunitReporter
    # Entry point for Inspec Reporter plugins
    class Plugin < Inspec.plugin(2)
      plugin_name :'inspec-junit-reporter'

      reporter :junit do
        require_relative 'inspec-junit-reporter/reporter'
        InspecPlugins::JunitReporter::Reporter
      end
    end
  end
end
