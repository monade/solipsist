
# frozen_string_literal: true

require_relative 'base_strategy'

begin
  require 'active_model_serializers'
rescue LoadError
  raise LoadError, "active_model_serializers gem is required for AMS strategy."
end

module Solipsist
  module SerializationStrategies
    class AmsStrategy < BaseStrategy
      def self.render_args(model, options = {}, params = {}, &fields_parser)
        _validate_serializer_exists!(model, ::AMS)

        base_options = {
          json: model,
          include: params[:include] || '*'
        }

        base_options[:fields] = fields_parser.call(params[:fields].to_unsafe_h) if params.key?(:fields) && fields_parser

        base_options.merge(options)
      end
    end
  end
end
