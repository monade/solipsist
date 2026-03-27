# frozen_string_literal: true

require 'spec_helper'
require 'solipsist/serialization_strategies/jsonapi_strategy'

describe Solipsist::SerializationStrategies::JsonapiStrategy do
  describe '.render_args' do
    let(:person) { Person.first }

    context 'with meta option' do
      it 'includes meta inside the json hash, not as a top-level render option' do
        result = described_class.render_args(person, { meta: { total: 1 } }, ActionController::Parameters.new({}))
        expect(result[:json][:meta]).to eq({ total: 1 })
        expect(result).not_to have_key(:meta)
      end
    end

    context 'without meta option' do
      it 'does not include a meta key in the json output' do
        result = described_class.render_args(person, {}, ActionController::Parameters.new({}))
        expect(result[:json]).not_to have_key(:meta)
      end
    end
  end
end
