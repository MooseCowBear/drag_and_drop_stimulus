FactoryBot.define do
  factory :task do
    title { "task" }
    description { "task description" }
    category { 1 }
    priority { 1 }
  end
end
