module Solipsist
  module ErrorHandling
    extend ActiveSupport::Concern

    def format_model_errors(model)
      format_errors(model.errors).merge!(id: model.id)
    end

    def format_errors(errors)
      {
        errors: errors,
        message: errors.full_messages.to_sentence,
        details: errors.details.to_h
      }.deep_dup
    end

    def render_errors(errors, status: :unprocessable_entity)
      render json: format_errors(errors), status:
    end
  end
end
