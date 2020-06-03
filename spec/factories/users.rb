FactoryBot.define do
  factory :user do
    email { 'test@example.com' }
    password { 'pwd' }
    password_confirmation { 'pwd' }
  end
end
