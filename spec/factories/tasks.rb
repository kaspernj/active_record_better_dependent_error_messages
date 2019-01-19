FactoryBot.define do
  factory :task do
    project
    sequence(:name) { |n| "Task #{n}" }
  end
end
