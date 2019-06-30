
module InspecPlugins
  module CliReporter
    class Plugin < Inspec.plugin(2)
      plugin_name :'inspec-cli-reporter'

      reporter :cli do
        require_relative 'inspec-cli-reporter/reporter'
        InspecPlugins::CliReporter::Reporter
      end
    end
  end
end
