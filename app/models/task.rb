class Task < ApplicationRecord
  belongs_to :user

  enum status: { pending: 0, inprogress: 1, completed: 2, archived: 3 }

  default_scope { where.not(status: statuses[:archived]) }

  scope :archived, -> { unscope(:where).where(status: statuses[:archived]) }
end
