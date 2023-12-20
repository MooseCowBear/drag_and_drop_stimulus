FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyString" }
    category { 1 }
    priority { 1 }
  end
end
