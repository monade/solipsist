# frozen_string_literal: true

module Solipsist
  module SerializationAdapter

    STRATEGY_PATHS = {
      ams: 'solipsist/serialization_strategies/ams_strategy',
      jsonapi: 'solipsist/serialization_strategies/jsonapi_strategy'
    }.freeze

    STRATEGY_CLASSES = {
      ams: 'Solipsist::SerializationStrategies::AmsStrategy',
      jsonapi: 'Solipsist::SerializationStrategies::JsonapiStrategy'
    }.freeze

    def self.render_args(model, options = {}, params: {}, &fields_parser)
      key = Solipsist.effective_serializer
      path = STRATEGY_PATHS[key]
      class_name = STRATEGY_CLASSES[key]
      raise ArgumentError, "Unknown serializer: #{key}" unless path && class_name

      require path
      strategy_class = Object.const_get(class_name)
      strategy_class.render_args(model, options, params, &fields_parser)
    end
  end
end
