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

ActiveModelSerializers.config.adapter = ActiveModelSerializers::Adapter::JsonApi
ActiveModel::Serializer.config.key_transform = :camel_lower

module My
  class Application < Rails::Application
  end
end

I18n.enforce_available_locales = false
RSpec::Expectations.configuration.warn_about_potential_false_positives = false

Rails.application.config.eager_load = false

Dir[File.expand_path('../support/*.rb', __FILE__)].each { |f| require f }

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
