module InspecPlugins
  module JsonReporter
    class Plugin < Inspec.plugin(2)
      plugin_name :'inspec-json-reporter'

      reporter :json do
        require_relative 'inspec-json-reporter/reporter'
        InspecPlugins::JsonReporter::Reporter
      end
    end
  end
end
