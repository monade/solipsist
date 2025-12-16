# frozen_string_literal: true

module AMS
  class PersonSerializer < ActiveModel::Serializer
    attributes :name
  end

  class ArticleSerializer < ActiveModel::Serializer
    attributes :title
  end

  class CustomPersonSerializer < ActiveModel::Serializer
    attributes :name, :email, :custom_field

    def custom_field
      'i_am_custom'
    end
  end
end
