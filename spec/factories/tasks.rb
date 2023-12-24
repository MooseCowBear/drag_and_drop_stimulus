FactoryBot.define do
  factory :task do
    title { "task" }
    description { "task description" }
    category { 1 }
    priority { 1 }
    completed { false }
    position { 0 }

    trait :completed do
      completed { true }
    end
  end

  factory :task_list, class: "Task" do
    sequence(:title) { |i| "Task#{i}" }
    description { "task description" }
    sequence(:position) { |i| i - 1}
  end
end
