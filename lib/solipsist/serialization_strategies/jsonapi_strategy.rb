# frozen_string_literal: true

require_relative 'base_strategy'

module Solipsist
  module SerializationStrategies
    class JsonapiStrategy < BaseStrategy
      def self.render_args(model, options = {}, params = {})
        _validate_serializer_exists!(model, ::JSONAPI)

        klass = _extract_model_class(model)
        serializer_class = options[:serializer] || ::JSONAPI.const_get("#{klass.name}Serializer")

        include_param = normalize_include_param(options[:include] || params[:include])

        json = serializer_class.new(model, include: include_param).serializable_hash
        clean_options = options.except(:serializer)
        { json: json }.merge(clean_options)
      end

      private

      def self.normalize_include_param(include_value)
        return [] if include_value.nil? || include_value.empty?

        if include_value.respond_to?(:split)
            include_value.split(',').map { |item| item.strip.to_sym }
        elsif include_value.respond_to?(:map)
            include_value.map(&:to_sym)
        else
            [include_value.to_sym]
        end
      end
    end
  end
end