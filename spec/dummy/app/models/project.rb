class Project < ApplicationRecord
  belongs_to :account

  has_many :tasks, dependent: :restrict_with_error

  before_destroy :before_destroy_cannot_delete_certain_id

private

  def before_destroy_cannot_delete_certain_id
    if id == 4849
      errors.add(:base, "cannot delete project 4849")
      throw :abort
    end
  end
end
