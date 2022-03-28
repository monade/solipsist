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
    def api_resources(name, options = { only: [:index, :destroy, :update, :create, :show] }, &block)
      resources name, options, &block
    end

    def api_resource(name, options = { only: [:index, :destroy, :update, :create, :show] })
      resource name, options, &block
    end

    def api_mass_resources(name, options = { only: [:index, :destroy, :update, :create, :show] }, &block)
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
