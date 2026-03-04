# frozen_string_literal: true

module JSONAPI
  class PersonSerializer
    include ::JSONAPI::Serializer
    attributes :name
    set_type :person
  end

  class ArticleSerializer
    include ::JSONAPI::Serializer
    attributes :title
    set_type :article
  end

  class CustomPersonSerializer
    include JSONAPI::Serializer
    set_key_transform :camel_lower
    set_type :person

    attributes :name, :email

    attribute :custom_field do |_person|
      'i_am_custom'
    end
  end

  class CustomUserSerializer
    include JSONAPI::Serializer
    set_key_transform :camel_lower
    set_type :user

    attributes :email

    attribute :custom_user_field do |_user|
      'i_am_a_custom_user'
    end
  end
end
