# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
describe PeopleController, type: :controller do
  let(:json_body) { JSON.parse(response.body) }

  context 'GET /people' do
    it 'returns a list of items' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(json_body.dig('data', 0, 'id')).to be_a(String)
    end
  end

  context 'GET /people/:id' do
    let(:person) { Person.first }

    it 'returns the item' do
      get :show, params: { id: person.id }
      expect(response).to have_http_status(:ok)
      expect(json_body.dig('data', 'id')).to be_a(String)
    end
  end

  context 'POST /people' do
    it 'default http status is 201' do
      post :create, params: { name: 'aaaaaaa' }
      expect(response).to have_http_status(:created)
    end

    it 'creates an item' do
      expect do
        post :create, params: { name: 'aaaaaaa' }
        expect(response).to have_http_status(:created)
        expect(json_body.dig('data', 'id')).to be_a(String)
      end.to change { Person.count }.by(1)
    end

    context 'custom status' do
      before do
        class PeopleController < ApplicationController
          def create
            default! @person, { status: :ok }
          end
        end
      end

      it 'can use custom status' do
        post :create, params: { name: 'aaaaaaa' }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'PUT /people/:id' do
    let(:person) { Person.first }

    it 'updates an item' do
      expect do
        put :update, params: { id: person.id, name: 'aaaaaaa' }
        expect(response).to have_http_status(:ok)
        expect(json_body.dig('data', 'attributes', 'name')).to eq('aaaaaaa')
      end.to change { person.reload.name }.to('aaaaaaa')
    end
  end

  context 'DELETE /people/:id' do
    let(:person) { Person.first }

    it 'destroys an item' do
      expect do
        delete :destroy, params: { id: person.id }
        expect(response).to have_http_status(:ok)
      end.to change { Person.count }.by(-1)
    end
  end
end
# rubocop:enable Metrics/BlockLength
