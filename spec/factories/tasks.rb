FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "title#{n}" }
    content { 'content' }
    status {:todo}
    deadline { 1.week.from_now.strftime('%Y/%-m/%-d %-H:%-M') }
    association :user
  end
end
