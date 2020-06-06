FactoryBot.define do
  factory :task, class: Task do
    id { 1 }
    # idを指定しない状態だとexpect(current_path).to eq task_path(task)が通らないため追加
    title { 'ランニング' }
    content { 'A公園' }
    status { 0 }
    deadline { '2020-6-20 7:00' }
    
    association :user,
      factory: :user,
      email: 'test1@example.com'
  end
    
  factory :re_task, class: Task do
    title { 'ランニング' }
    content { 'A公園' }
    status { 0 }
    deadline { '2020-6-20 7:00' }
    
    association :user,
      factory: :user,
      email: 'test2@example.com'
  end
end
