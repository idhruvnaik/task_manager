class Task < ApplicationRecord
  belongs_to :user

  enum status: { pending: 0, inprogress: 1, completed: 2, archived: 3 }
end
