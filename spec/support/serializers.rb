class PersonSerializer < ActiveModel::Serializer
  attributes :name
end

class ArticleSerializer < ActiveModel::Serializer
  attributes :title
end
