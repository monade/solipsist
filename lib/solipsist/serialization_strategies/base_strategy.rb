# frozen_string_literal: true

module Solipsist
  module SerializationStrategies
    class BaseStrategy
      class << self
        def _validate_serializer_exists!(model, namespace)
          klass = _extract_model_class(model)
          return unless klass

          serializer_name = "#{klass.name}Serializer"
          namespace.const_get(serializer_name)
        rescue NameError
          raise "No #{namespace} serializer found for #{klass}"
        end

        def _extract_model_class(model)
          case model
          when ActiveRecord::Relation then model.klass
          when Array then model.first&.class
          else model.class
          end
        end
      end
    end
  end
end
