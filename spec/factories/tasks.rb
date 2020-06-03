FactoryBot.define do
  factory :task do
    association :user
    title { 'ランニング' }
    content { 'A公園' }
    status { 0 }
    deadline { '2020-6-20 7:00' }
  end
end
