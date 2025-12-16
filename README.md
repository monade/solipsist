![Tests](https://github.com/monade/solipsist/actions/workflows/test.yml/badge.svg)

# Solipsist

A simplified way to write JSON APIs in Rails, taking use of Cancancan and ActiveModel::Serializers.

Less code to write, more fun!

## Installation

**Note:** This project uses a fork of the original [jsonapi-serializer](https://github.com/jsonapi-serializer/jsonapi-serializer) gem, maintained at [monade/jsonapi-serializer](https://github.com/monade/jsonapi-serializer). This fork is not currently published on RubyGems. To use it, you must point to the GitHub repository in your Gemfile:

```ruby
gem 'jsonapi-serializer', git: 'https://github.com/monade/jsonapi-serializer.git', branch: 'master'
```

### Choose your serializer

**Controller experience stays the same!**

No matter which serializer you use, your controllers and routes do not change. Solipsist handles everything for you. If you switch to jsonapi-serializer, you only need to provide a compatible serializer class for your models.

#### Example with jsonapi-serializer

If you want to customize the output for a model (e.g., `Person`), just define a serializer like this:

```ruby
# app/serializers/base_serializer.rb
class BaseSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower
  attributes :name, :email
end

# app/serializers/person_serializer.rb
class PersonSerializer < BaseSerializer
  set_type :persons
  attributes :name, :email

  attribute :custom_field do |person|
    "custom for \\#{person.name}"
  end
end
```

Solipsist will automatically use this serializer when `Solipsist.serializer = :jsonapi` is set.

Solipsist supports both [ActiveModel::Serializers (AMS)](https://github.com/rails-api/active_model_serializers) and [jsonapi-serializer](https://github.com/jsonapi-serializer/jsonapi-serializer).
By default, AMS is used, but you can switch to jsonapi-serializer in two ways:

**1. Via initializer:**

Create a file at `config/initializers/solipsist.rb` with:

```ruby
Solipsist.serializer = :jsonapi # or :ams
```

**2. Via environment variable:**

```sh
SOLIPSIST_SERIALIZER=jsonapi # or ams
```

If neither is set, AMS will be used by default.

## FAQ

### Do I need to change anything in my controllers?

No: the controller interface does not change. Solipsist will automatically select and configure the correct serializer based on the configured serializer.

## Philosophy
Why keep re-implementing the same things?

A CRUD looks always the same in 90% of cases. So why don't have a default set of actions, and override what is different?

## Usage

Add Solipsist to your ApplicationController:

```ruby
class ApplicationController < ActionController::Base
  include Solipsist
end
```

Now the controller will be super dry!

```ruby
# Router
api_resources :people

# Controller
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
```

### Mass actions

You just have to add the `accept_mass_actions` method to your controller!

```ruby
# Router
api_mass_resources :people

# Controller
class PeopleController < ApplicationController
  accept_mass_actions
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
```
