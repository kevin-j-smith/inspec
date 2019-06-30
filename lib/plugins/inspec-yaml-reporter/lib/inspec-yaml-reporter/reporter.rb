# frozen_string_literal: true
  
require "yaml"

module InspecPlugins
  module YamlReporter
    class Reporter < Inspec.plugin(2, :reporter)

      def output(output, newline = true)
        puts "YamlReporter.output: #{output}"
      end

      def resolved_output
        puts "YamlReporter.resolved_output:"
      end

      def resolve
        puts "YamlReporter.resolve:"
      end
    end

    def render
      # TODO: this no longer exists.
      #output(Inspec::Reporters::Json.new({ run_data: run_data }).report.to_yaml, false)
    end

    def report
      {
        platform: platform,
        profiles: profiles,
        statistics: {
          duration: run_data[:statistics][:duration],
        },
        version: run_data[:version],
      }
    end
  end
end
