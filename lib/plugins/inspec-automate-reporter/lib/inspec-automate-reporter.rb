module InspecPlugins
  module AutomateReporter
    class Plugin < Inspec.plugin(2)
      plugin_name :'inspec-automate-reporter'

      reporter :automate do
        require_relative 'inspec-automate-reporter/reporter'
        InspecPlugins::AutomateReporter::Reporter
      end
    end
  end
end
