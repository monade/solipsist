# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ::Solipsist

  def current_user
    @current_user ||= User.first
  end
end

class PeopleController < ApplicationController
  load_and_authorize_resource

  def index
    default! @people
  end

  def show
    default! @person
  end

  def create
    default! @person
  end

  def update
    default! @person
  end

  def destroy
    default! @person
  end

  private

  def create_params
    params.permit(:name, :email)
  end

  def update_params
    params.permit(:name, :email)
  end
end

class ArticlesController < ApplicationController
  accept_mass_actions
  load_and_authorize_resource

  def index
    default! @articles
  end

  def show
    default! @article
  end

  def create
    default! @article
  end

  def update
    default! @article
  end

  def destroy
    default! @article
  end

  private

  def create_params
    mass_params_permit(:title)
  end

  def update_params
    mass_params_permit(:id, :title)
  end
end

class TransactionArticlesController < ApplicationController
  accept_mass_actions
  load_and_authorize_resource :article

  def index
    default! @articles
  end

  def show
    default! @article
  end

  def create
    default! @article
  end

  def update
    default! @article
  end

  def destroy
    default! @article
  end

  private

  def create_params
    params.permit(:name, :email)
  end

  def update_params
    params.permit(:name, :email)
  end
end

Rails.application.initialize!

Rails.application.routes.draw do
  api_resources :people
  api_mass_resources :articles
end
