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

      it 'does not pass meta as a rails render option' do
        result = described_class.render_args(person, { meta: { total: 1 } }, ActionController::Parameters.new({}))
        expect(result.keys).to contain_exactly(:json)
      end
    end
  end
end
