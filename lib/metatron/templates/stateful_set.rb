# frozen_string_literal: true

module Metatron
  module Templates
    # Template for basic StatefulSet k8s resource
    class StatefulSet < Template
      include Concerns::Annotated
      include Concerns::PodProducer
      include Concerns::Namespaced

      attr_accessor :replicas, :service_name, :pod_management_policy, :enable_service_links

      def initialize(name, replicas: 1)
        super(name)
        @replicas = replicas
        @api_version = "apps/v1"
        @pod_management_policy = "OrderedReady"
        @enable_service_links = true
        @service_name = name
      end

      alias enableServiceLinks enable_service_links
      alias podManagementPolicy pod_management_policy
      alias serviceName service_name

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def render
        {
          apiVersion:,
          kind:,
          metadata: {
            name:,
            labels: { "#{label_namespace}/name": name }.merge(additional_labels)
          }.merge(formatted_annotations).merge(formatted_namespace),
          spec: {
            replicas:,
            serviceName:,
            enableServiceLinks:,
            strategy: { type: "RollingUpdate", rollingUpdate: { maxSurge: 2, maxUnavailable: 0 } },
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
                .merge(formatted_affinity)
                .merge(formatted_tolerations)
                .compact
            }
          }
        }.merge(volume_claim_templates)
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength
    end
  end
end
