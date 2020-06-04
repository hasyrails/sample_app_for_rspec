FactoryBot.define do
  factory :task, class: Task do
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

# dammy push (branch #2)
