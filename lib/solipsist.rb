# frozen_string_literal: true

require 'active_support'

module Solipsist
  extend ActiveSupport::Autoload
  extend ActiveSupport::Concern

  autoload :ErrorHandling
  autoload :Actions
  autoload :MassActions

  include ErrorHandling
  include Actions
  include MassActions

  included do
    rescue_from ActiveRecord::RecordInvalid do |e|
      render_errors(e.record.errors)
    end
  end
end

module ActionDispatch::Routing
  class Mapper
    # @param [Symbol] name
    # @param [Hash] options
    # @param [Proc] block
    def api_resources(name, options = { only: [:index, :destroy, :update, :create, :show] }, &block)
      resources name, options, &block
    end

    # @param [Symbol] name
    # @param [Hash] options
    def api_resource(name, options = { only: [:index, :destroy, :update, :create, :show] }, &block)
      resource name, options, &block
    end

    # @param [Symbol] name
    # @param [Hash] options
    # @param [Proc] block
    def api_mass_resources(name, options = { only: [:index, :destroy, :update, :create, :show] }, &block)
      resources name, options do
        collection do
          put '', action: :update
          delete '', action: :destroy
        end
        block&.call
      end
    end
  end
end
