# frozen_string_literal: true

module Metatron
  module Templates
    # The DaemonSet Kubernetes resource
    class DaemonSet < Template
      include Concerns::Annotated
      include Concerns::Namespaced
      include Concerns::PodProducer

      attr_accessor :replicas, :additional_labels

      def initialize(name)
        super(name)
        @api_version = "apps/v1"
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def render
        {
          apiVersion:,
          kind:,
          metadata: {
            name:,
            labels: { "#{label_namespace}/name": name }.merge(additional_labels)
          }.merge(formatted_annotations).merge(formatted_namespace),
          spec: {
            selector: {
              matchLabels: { "#{label_namespace}/name": name }.merge(additional_pod_labels)
            },
            template: {
              metadata: {
                labels: { "#{label_namespace}/name": name }.merge(additional_pod_labels)
              }.merge(formatted_pod_annotations),
              spec: {
                terminationGracePeriodSeconds:,
                containers: containers.map(&:render),
                init_containers: init_containers.any? ? init_containers.map(&:render) : nil
              }.merge(formatted_volumes)
                .merge(formatted_security_context)
                .merge(formatted_tolerations)
                .compact
            }
          }
        }
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength
    end
  end
end
