class Account < ApplicationRecord
  include ActiveRecordBetterDependentErrorMessages::DestroyModule

  has_many :projects, dependent: :destroy
end
