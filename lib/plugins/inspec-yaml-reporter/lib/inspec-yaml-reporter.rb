module InspecPlugins
  module YamlReporter
    class Plugin < Inspec.plugin(2)
      plugin_name :'inspec-yaml-reporter'

      reporter :json do
        require_relative 'inspec-yaml-reporter/reporter'
        InspecPlugins::YamlReporter::Reporter
      end
    end
  end
end
