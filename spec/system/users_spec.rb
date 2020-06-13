require 'rails_helper'

RSpec.describe 'Users', type: :system do  
  describe 'ログイン前' do
    let(:user) { build(:user) }
    let(:other_user) { build(:user)}
    describe 'ユーザー新規登録' do
    before do
      visit new_user_path
      sleep 1
    end
      context 'フォームの入力値が正常' do     
        it 'ユーザーの新規作成が成功する' do
          fill_in 'Email', with: user.email
          fill_in "Password", with: 'password'
          fill_in 'Password confirmation', with: 'password'
          sleep 1
          
          click_button 'SignUp'
          sleep 1
          
          expect(page).to have_content 'User was successfully created.'
          expect(current_path).to eq login_path
          sleep 1
        end
      end
      
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          sleep 1
          
          expect(page).to have_content "Email can't be blank"
          expect(current_path).to eq users_path
          expect(User.all.size).to eq 0
          sleep 1
        end
      end
      
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          sleep 1
          
          click_on 'SignUp'
          sleep 1

          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          sleep 1
          
          expect(page).to have_content "Email has already been taken"
          expect(current_path).to eq users_path
          expect(User.all.size).to eq 1
          sleep 1
        end
      end
    end
    
    describe 'マイページ' do
      let(:user) { create(:user) }
      before do
        visit user_path(user)
        sleep 1
      end
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end
  end
  
  describe 'ログイン後' do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:task) { build(:task) }
  before do
    login(user)
  end
  
    describe 'ユーザー編集' do
    before do
      visit user_path(user)
      click_on 'Edit'
      sleep 1
    end

      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          fill_in 'Email', with: user.email
          fill_in "Password", with: 'edited_pwd'
          fill_in 'Password confirmation', with: 'edited_pwd'
          sleep 1
          
          click_button 'Update'
          sleep 1

          expect(page).to have_content 'User was successfully updated.'

          expect(current_path).to eq user_path(user)
          sleep 1
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do 
          fill_in 'Email', with: ''
          # 指定しない状態だと、予めフォームに入力されているメールアドレスがあるので空となっていない。
          
          fill_in 'Password', with: 'edited_pwd'
          fill_in 'Password confirmation', with: 'edited_pwd'
          click_button 'Update'
          sleep 1
          
          expect(page).to have_content "Email can't be blank"
          expect(current_path).to eq user_path(user)
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          fill_in 'Email', with: other_user.email
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'Update'
          sleep 1
          
          expect(page).to have_content "Email has already been taken"
          expect(current_path).to eq user_path(user)
        end
      end
    end

      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          login(other_user)
          sleep 1

          visit edit_user_path(user)
          sleep 1

          expect(page).to have_content 'Forbidden access.'
          expect(current_path).to eq user_path(other_user)
        end
      end
    
      
    describe 'マイページ' do
    before do
      visit new_task_path
    end
        
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          
          fill_in 'Title', with: task.title
          fill_in 'Content', with: task.content
          select task.status, from: 'task_status'
          fill_in 'Deadline', with: task.deadline
          click_on 'Create Task'
          
          visit tasks_path
          sleep 1
          
          # ログインしたユーザーが作成したタスクが表示されているか
          expect(page).to have_content task.title
          expect(page).to have_content task.content
          expect(page).to have_content task.status
          expect(page).to have_content task.deadline.strftime('%Y/%-m/%-d %-H:%-M')
        end
      end
    end
  end
end
