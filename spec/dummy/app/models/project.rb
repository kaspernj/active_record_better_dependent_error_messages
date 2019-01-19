class Project < ApplicationRecord
  belongs_to :account

  has_many :tasks, dependent: :restrict_with_error
end
