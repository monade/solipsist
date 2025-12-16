# frozen_string_literal: true

require_relative 'serialization_strategies/ams_strategy'
require_relative 'serialization_strategies/jsonapi_strategy'

module Solipsist
  module SerializationAdapter
    STRATEGIES = {
      ams: SerializationStrategies::AmsStrategy,
      jsonapi: SerializationStrategies::JsonapiStrategy
    }.freeze

    def self.render_args(model, options = {}, params: {}, &fields_parser)
      strategy_class = STRATEGIES.fetch(Solipsist.effective_serializer) do
        raise ArgumentError, "Unknown serializer: #{Solipsist.effective_serializer}"
      end
      strategy_class.render_args(model, options, params, &fields_parser)
    end
  end
end
