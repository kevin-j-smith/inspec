# frozen_string_literal: true

require "json"
require "yaml"

module InspecPlugins
  module JsonAutomateReporter
    # The Json Automate Reporter will report run results in
    #   Json that can be consumed by the Automate server
    class Reporter < Inspec.plugin(2, :reporter)
      def initialize(config)
        config["child_reporter"] = "inspec-json-reporter"
        super(config)

        @profiles = []
      end

      def render
        @child_reporter.run_data = @run_data
        @child_reporter.render
        output(report.to_json, false)
        super
      end

      def report # rubocop:disable Metrics/MethodLength
        # grab profiles from the json parent class
        json_reporter_output = JSON.parse(@child_reporter.rendered_output)
        @profiles = json_reporter_output["profiles"]

        output = {
          platform: json_reporter_output["platform"],
          profiles: merge_profiles,
          statistics: {
            duration: @run_data[:statistics][:duration],
          },
          version: @run_data[:version],
        }

        # optional json-config passthrough options
        %w{node_name environment roles job_uuid passthrough}.each do |option|
          output[option.to_sym] = @config[option] unless @config[option].nil?
        end
        output
      end

      private

      def merge_profiles
        @profiles.each do |profile|
          next unless profile.key?(:parent_profile)

          parent_profile = find_master_parent(profile)
          merge_controls(parent_profile, profile)
          merge_depends(parent_profile, profile)
        end

        # delete child profiles
        @profiles.delete_if { |p| p.key?(:parent_profile) }

        @profiles
      end

      def find_master_parent(profile)
        return profile unless profile.key?(:parent_profile)

        # rubocop:disable Metrics/LineLength
        parent_profile = @profiles.select { |parent| parent[:name] == profile[:parent_profile] }.first
        # rubocop:enable Metrics/LineLength
        find_master_parent(parent_profile)
      end

      def merge_controls(parent, child)
        parent[:controls].each do |control|
          # rubocop:disable Metrics/LineLength
          child_control = child[:controls].select { |c| c[:id] == control[:id] }.first
          next if child_control.nil?

          control.each do |name, _value|
            child_value = child_control[name]
            next if child_value.nil? || (child_value.respond_to?(:empty?) && child_value.empty?)

            control[name] = child_value
          end
          # rubocop:enable Metrics/LineLength
        end
      end

      def merge_depends(parent, child)
        return unless child.key?(:depends)

        child[:depends].each do |d|
          parent[:depends] << d
        end
      end
    end
  end
end
