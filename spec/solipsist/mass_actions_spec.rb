# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
describe ArticlesController, type: :controller do
  let(:json_body) { JSON.parse(response.body) }

  context 'GET /articles' do
    it 'returns a list of items' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(json_body.dig('data', 0, 'id')).to be_a(String)
    end
  end

  context 'GET /articles/:id' do
    let(:article) { Article.first }

    it 'returns the item' do
      get :show, params: { id: article.id }
      expect(response).to have_http_status(:ok)
      expect(json_body.dig('data', 'id')).to be_a(String)
    end
  end

  context 'POST /articles' do
    it 'creates an item' do
      expect do
        post :create, params: { title: 'aaaaaaa' }
        expect(response).to have_http_status(:created)
        expect(json_body.dig('data', 'id')).to be_a(String)
      end.to change { Article.count }.by(1)
    end

    it 'creates multiple items' do
      expect do
        post :create, params: { items: [{ title: 'aaaaaaa' }, { title: '123123' }] }
        expect(response).to have_http_status(:ok)
        expect(json_body.dig('data', 0, 'id')).to be_a(String)
        expect(json_body.dig('data', 1, 'id')).to be_a(String)
        expect(json_body.dig('data', 0, 'attributes', 'title')).to eq('aaaaaaa')
        expect(json_body.dig('data', 1, 'attributes', 'title')).to eq('123123')
      end.to change { Article.count }.by(2)
    end

    context 'custom status' do
      before do
        class ArticlesController < ApplicationController
          def create
            default! @article, { status: :ok }
          end
        end
      end

      it 'can use custom status' do
        post :create, params: { title: 'aaaaaaa' }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'PUT /articles/:id' do
    let(:article) { Article.first }
    let(:articles) { Article.limit(2) }

    it 'updates an item' do
      expect do
        put :update, params: { id: article.id, title: 'aaaaaaa' }
        expect(response).to have_http_status(:ok)
        expect(json_body.dig('data', 'attributes', 'title')).to eq('aaaaaaa')
      end.to change { article.reload.title }.to('aaaaaaa')
    end

    it 'updates all items' do
      expect do
        put :update, params: { items: articles.map.with_index { |a, i| { id: a.id, title: "aaa#{i}" } } }
        expect(response).to have_http_status(:ok)
        expect(json_body.dig('data', 0, 'attributes', 'title')).to eq('aaa0')
        expect(json_body.dig('data', 1, 'attributes', 'title')).to eq('aaa1')
      end.to change { article.reload.title }.to('aaa0')
    end
  end

  context 'DELETE /articles/:id' do
    let(:article) { Article.first }
    let(:articles) { Article.limit(2) }

    it 'destroys an item' do
      expect do
        delete :destroy, params: { id: article.id }
        expect(response).to have_http_status(:ok)
      end.to change { Article.count }.by(-1)
    end

    it 'destroys all items' do
      expect do
        delete :destroy, params: { items: articles.map { |a| { id: a.id } } }
        expect(response).to have_http_status(:ok)
      end.to change { Article.count }.by(-2)
    end
  end
end
# rubocop:enable Metrics/BlockLength
