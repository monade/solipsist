# frozen_string_literal: true

module Solipsist
  # A module to define default actions for a controller
  module Actions
    extend ActiveSupport::Concern

    protected

    # @param [Object] model
    # @param [Hash] options
    # @param [Proc] block
    def default_save!(model, options = {}, &block)
      _implicit_create_action(model, options, &block)
    end

    # @param [Object] model
    # @param [Hash] options
    def render_default!(model, options = {})
      _implicit_render(model, options)
    end

    # @param [Object] model
    # @param [Hash] options
    # @param [Proc] block
    # @raise [RuntimeError]
    def default!(model, options = {}, &block)
      case params[:action]
      when 'update'
        _implicit_update_action(model, options, &block)
      when 'destroy'
        _implicit_destroy_action(model, options, &block)
      when 'create'
        _implicit_create_action(model, options, &block)
      when 'index', 'show'
        render_default!(model, options = {}, &block)
      else
        raise "No implicit action for #{params[:action]}"
      end
    end

    # @param [#update!] model
    # @param [Hash] options
    def _implicit_update_action(model, options)
      model.update!(update_params)
      block_given? ? yield : _implicit_render(model, options)
    end

    # @param [#destroy!] model
    # @param [Hash] options
    def _implicit_destroy_action(model, options)
      model.destroy!
      block_given? ? yield : _implicit_render(model, options)
    end

    # @param [#save!] model
    # @param [Hash] options
    def _implicit_create_action(model, options)
      model.save!
      block_given? ? yield : _implicit_render(model, options)
    end

    # @param [Object] model
    # @param [Hash] options
    def _implicit_render(model, options)
      base_options = { json: model, include: params[:include] || '*' }
      base_options[:fields] = parse_fields(params[:fields].to_unsafe_h) if params.key?(:fields)

      render(base_options.merge(options))
    end

    # @param [Hash<String, String>] fields
    def parse_fields(fields)
      fields.map { |key, value| [key.camelcase(:lower).to_sym, value.split(',').map!(&:underscore)] }.to_h
    end
  end
end
