# Solipsist

A simplified way to write JSON APIs in Rails, taking use of Cancancan and ActiveModel::Serializers.

Less code to write, more fun!

## Installation

Add the gem to your Gemfile

```ruby
  gem 'solipsist', github: 'monade/solipsist'
```

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
