FactoryBot.define do
  factory :user, class: User do
    id { 1 }
    email { 'test@example.com' }
    password { 'pwd' }
    password_confirmation { 'pwd' }
  end
  
  factory :re_user, class: User do
    id { 2 }
    email { 'test@example.com' }
    password { 'pwd' }
    password_confirmation { 'pwd' }
  end

  factory :edited_user, class: User do
    email { 'edited@example.com' }
    password { 'edited_pwd' }
    password_confirmation { 'edited_pwd' }
  end
end
