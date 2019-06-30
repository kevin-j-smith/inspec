# frozen_string_literal: true
  
module InspecPlugins
  module JsonReporter
    class Reporter < Inspec.plugin(2, :reporter)

      def output(output, newline = true)
        puts "JsonReporter.output: #{output}"
      end

      def resolved_output
        puts "JsonReporter.resolved_output:"
      end

      def resolve
        puts "JsonReporter.resolve:"
      end
    end
  end
end
