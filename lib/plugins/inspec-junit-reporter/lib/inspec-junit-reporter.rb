
module InspecPlugins
  module JunitReporter
    class Plugin < Inspec.plugin(2)
      plugin_name :'inspec-unit-reporter'

      reporter :junit do
        require_relative 'inspec-junit-reporter/reporter'
        InspecPlugins::JunitReporter::Reporter
      end
    end
  end
end
