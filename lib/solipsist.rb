# frozen_string_literal: true

require 'active_support'
require_relative 'solipsist/serialization_adapter'

module Solipsist

  class << self
    attr_accessor :serializer
  end

  # Set serializer from initializer if present, otherwise fallback to ENV or default
  def self.effective_serializer
    return @serializer if @serializer
    env = ENV['SOLIPSIST_SERIALIZER']&.to_sym
    env == :jsonapi ? :jsonapi : :ams
  end

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
    def api_resources(name, only: [:index, :destroy, :update, :create, :show], **options, &block)
      resources name, only:, **options, &block
    end

    # @param [Symbol] name
    # @param [Hash] options
    def api_resource(name, only: [:index, :destroy, :update, :create, :show], **options, &block)
      resource name, only:, **options, &block
    end

    # @param [Symbol] name
    # @param [Hash] options
    # @param [Proc] block
    def api_mass_resources(name, only: [:index, :destroy, :update, :create, :show], **options, &block)
      resources name, only:, **options do
        collection do
          put '', action: :update
          delete '', action: :destroy
        end
        block&.call
      end
    end
  end
end
