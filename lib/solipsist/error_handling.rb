# frozen_string_literal: true

module Solipsist
  # A module to render errors in a consistent format
  module ErrorHandling
    extend ActiveSupport::Concern

    # @param [#errors, #id] model
    # @return [Hash]
    def format_model_errors(model)
      format_errors(model.errors).merge!(id: model.id)
    end

    # @param [#full_messages, #details] errors
    # @return [Hash]
    def format_errors(errors)
      {
        errors: errors,
        message: errors.full_messages.to_sentence,
        details: errors.details.to_h
      }.deep_dup
    end

    # @param [#full_messages, #details] errors
    # @param [Symbol] status
    def render_errors(errors, status: :unprocessable_entity)
      render json: format_errors(errors), status: status
    end
  end
end
