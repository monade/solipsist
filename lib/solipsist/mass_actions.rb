# frozen_string_literal: true

module Solipsist
  module MassActions
    extend ActiveSupport::Concern

    module ClassMethods
      def accept_mass_actions(options = {})
        options.assert_valid_keys(:transaction)

        before_action :build_mass_resources, only: :create
        before_action :load_mass_resources, only: [:update, :destroy]

        _mass_actions_options.merge!(options)
        _mass_actions_options[:mass] = true
      end

      protected

      def _mass_actions_options
        @_mass_actions_options ||= {}
      end
    end

    protected

    def _implicit_create_action(model, options)
      if model.respond_to?(:length)
        _implicit_mass_create_action(model, options)
      else
        super
      end
    end

    def _implicit_update_action(model, options)
      if model.respond_to?(:length)
        _implicit_mass_update_action(model, options)
      else
        super
      end
    end

    def _implicit_destroy_action(model, options)
      if model.respond_to?(:length)
        _implicit_mass_destroy_action(model, options)
      else
        super
      end
    end

    def mass_params_permit(*args)
      if mass_params.is_a?(Array)
        mass_params.map { |p| p.permit(*args) }
      else
        params.permit(*args)
      end
    end

    def mass_params
      params[:items] || params[:_json]
    end

    def build_mass_resources
      resources = build_resources
      assign_resources!(resources)
    end

    def load_mass_resources
      resources = query_resources
      assign_resources!(resources)
    end

    def assign_resources!(resources)
      if resources.respond_to?(:length)
        _cancancan_resource_wrapper.send('collection_instance=', resources)
      end
      _cancancan_resource_wrapper.send('resource_instance=', resources)
    end

    def build_resources
      data = _cancancan_resource_params
      if data.respond_to?(:length)
        data.map { |par| _cancancan_resource_class.new(par) }
      else
        _cancancan_resource_wrapper.send(:load_resource_instance)
      end
    end

    def query_resources
      data = mass_params
      if data.respond_to?(:length)
        find_in_order(data.map { |e| e[:id].to_s })
      else
        _cancancan_resource_wrapper.send(:load_resource_instance)
      end
    end

    def find_in_order(ids)
      _cancancan_resource_class.find(ids).index_by{ |e| e.id.to_s }.slice(*ids).values
    end

    def _cancancan_resource_params
      _cancancan_resource_wrapper.send(:resource_params)
    end

    def _cancancan_resource_class
      _cancancan_resource_wrapper.send(:resource_class)
    end

    def _cancancan_resource_wrapper
      @_cancancan_resource_wrapper ||= self.class.cancan_resource_class.new(self, nil, {})
    end

    private

    def _mass_actions_options
      self.class._mass_actions_options
    end

    def _implicit_mass_create_action(models, options)
      saved_models = models.filter(&:save)
      errored_models = models - saved_models
      errors = { errors: errored_models.map { |m| format_model_errors(m) } }
      return render json: errors, status: :unprocessable_entity if saved_models.none?

      block_given? ? yield : _implicit_render(saved_models, options.merge(meta: errors))
    end

    def _implicit_mass_destroy_action(models, options)
      destroyed_models = models.filter(&:destroy)
      errored_models = models - destroyed_models
      errors = { errors: errored_models.map { |m| format_model_errors(m) } }
      return render json: errors, status: :unprocessable_entity if destroyed_models.none?

      block_given? ? yield : _implicit_render(destroyed_models, options.merge(errors: errors))
    end

    def _implicit_mass_update_action(models, options)
      update_params.each_with_index do |params, i|
        models[i]&.assign_attributes(params.to_h.except('id').dup)
      end
      _implicit_mass_create_action(models, options)
    end

    def _implicit_render(model, options)
      base_options = { json: model, include: params[:include] || '*' }
      base_options[:fields] = parse_fields(params[:fields].to_unsafe_h) if params.key?(:fields)

      render(base_options.merge(options))
    end

    def parse_fields(fields)
      fields.map { |key, value| [key.camelcase(:lower).to_sym, value.split(',').map!(&:underscore)] }.to_h
    end
  end
end
