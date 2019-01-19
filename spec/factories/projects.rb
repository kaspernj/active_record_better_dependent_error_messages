FactoryBot.define do
  factory :project do
    account
    sequence(:name) { |n| "Project #{n}" }
  end
end
