
module InspecPlugins
  module JsonAutomateReporter
    class Plugin < Inspec.plugin(2)
      plugin_name :'inspec-json_automate-reporter'

      reporter :json_automate do
        require_relative 'inspec-json_automate-reporter/reporter'
        InspecPlugins::JsonAutomateReporter::Reporter
      end
    end
  end
end
