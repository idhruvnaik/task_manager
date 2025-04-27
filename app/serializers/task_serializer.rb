class TaskSerializer < ActiveModel::Serializer
  attributes :title, :description, :status, :created_at, :updated_at
end
