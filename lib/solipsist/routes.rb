# frozen_string_literal: true

module Solipsist
  module Routes
    extend ActiveSupport::Concern

    def api_resources(name, options = { only: [:index, :destroy, :update, :create, :show] }, &block)
      resources name, options do
        collection do
          put '', action: :update
          delete '', action: :destroy
        end
        block.call if block
      end
    end
  end
end

module ActionDispatch::Routing
  class RouteSet #:nodoc:
    # Ensure Devise modules are included only after loading routes, because we
    # need devise_for mappings already declared to create filters and helpers.
    prepend Solipsist::RouteSet
  end

  class Mapper
    def api_resources(name, options = { only: [:index, :destroy, :update, :create, :show] }, &block)
      resources name, options do
        collection do
          put '', action: :update
          delete '', action: :destroy
        end
        block.call if block
      end
    end
  end
end
