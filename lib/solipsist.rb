# frozen_string_literal: true

require 'active_support'
require_relative 'solipsist/serialization_adapter'

module Solipsist

  class << self
    attr_accessor :serializer
    attr_accessor :ams_serializers_namespace
    attr_accessor :jsonapi_serializers_namespace
  end

  # Set serializer from initializer if present, otherwise default to :ams
  def self.effective_serializer
    @serializer || :ams
  end

  # Set AMS serializers namespace from initializer if present, otherwise default to Object
  def self.effective_ams_namespace
    @ams_serializers_namespace || Object
  end

  # Set JSONAPI serializers namespace from initializer if present, otherwise default to JSONAPI
  def self.effective_jsonapi_namespace
    @jsonapi_serializers_namespace || JSONAPI
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
