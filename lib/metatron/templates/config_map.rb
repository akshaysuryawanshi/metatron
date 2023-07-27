# frozen_string_literal: true

module Metatron
  module Templates
    # The ConfigMap Kubernetes resource
    class ConfigMap < Template
      include Concerns::Annotated
      include Concerns::Namespaced

      attr_accessor :additional_labels, :type, :data

      def initialize(name, data = {})
        super(name)
        @data = data
        @additional_labels = {}
      end

      def render
        {
          apiVersion:,
          kind:,
          metadata: {
            name:,
            labels: { "#{label_namespace}/name": name }.merge(additional_labels)
          }.merge(formatted_annotations).merge(formatted_namespace),
          data:
        }
      end
    end
  end
end
