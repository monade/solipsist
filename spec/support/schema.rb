require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

class User < ActiveRecord::Base
end

class Person < ActiveRecord::Base
  has_many :articles
end

class Article < ActiveRecord::Base
  belongs_to :person
end

module Schema
  def self.create
    ActiveRecord::Migration.verbose = false

    ActiveRecord::Schema.define do
      create_table :users, force: true do |t|
        t.string   :email
        t.timestamps null: false
      end

      create_table :people, force: true do |t|
        t.string   :name
        t.string   :email
        t.boolean  :terms_and_conditions, default: false
        t.timestamps null: false
      end

      create_table :articles, force: true do |t|
        t.integer  :person_id
        t.string   :title
        t.text     :body
        t.integer   :status
        t.timestamps null: false
      end
    end

    person = Person.create!(name: 'john doe', email: 'e@mail.com', terms_and_conditions: true)
    10.times do |i|
      article = Article.create!(person: person, title: "Some article #{i}", body: 'hello!', status: 0)
    end

    User.create!(email: 'admin@admin.com')
  end
end
