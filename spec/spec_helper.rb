# frozen_string_literal: true

require 'logger'
require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'rspec/rails'
require 'cancancan'
require 'active_model_serializers'
require 'solipsist'
require 'jsonapi/serializer'

module My
  class Application < Rails::Application
  end
end

I18n.enforce_available_locales = false
RSpec::Expectations.configuration.warn_about_potential_false_positives = false

Rails.application.config.eager_load = false

support_dir = File.expand_path('support', __dir__)
Dir[File.join(support_dir, '*.rb')].each { |f| require f }

SERIALIZER_BACKEND = Solipsist.serializer

if SERIALIZER_BACKEND == :jsonapi
  PersonSerializer = JSONAPI::PersonSerializer
  ArticleSerializer = JSONAPI::ArticleSerializer
else
  ActiveModelSerializers.config.adapter = ActiveModelSerializers::Adapter::JsonApi
  ActiveModel::Serializer.config.key_transform = :camel_lower
  PersonSerializer = AMS::PersonSerializer
  ArticleSerializer = AMS::ArticleSerializer
end

RSpec.configure do |config|
  config.before(:suite) do
    Schema.create
  end

  config.around(:each) do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
