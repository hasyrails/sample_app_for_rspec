require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          new_user = FactoryBot.build(:user)

          visit new_user_path
          sleep 1

          fill_in 'Email', with: new_user.email
          fill_in "Password", with: 'password'
          # fill_in "Password", with: new_user.password では入力されない
          # sorceryでは「password」はvirtual attribute(DBに存在しない)→ActiveRecordメソッドで呼び出せない。
          fill_in 'Password confirmation', with: 'password'
          # fill_in "Password confirmation", with: new_user.password_confirmation では入力されない
          # sorceryでは「password_confirmation」はvirtual attribute(DBに存在しない)→ActiveRecordメソッドで呼び出せない。
          
          sleep 1

          click_button 'SignUp'

          sleep 1

          expect(page).to have_content 'User was successfully created.'
          expect(current_path).to eq login_path
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          user = FactoryBot.build(:user)

          visit new_user_path
          sleep 1
        
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          sleep 1

          expect(page).to have_content "Email can't be blank"
          expect(current_path).to eq users_path
        
          expect(User.all.size).to eq 0
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          user = FactoryBot.create(:user)
          re_user = FactoryBot.build(:re_user)
        
          visit new_user_path
          sleep 1
        
          fill_in 'Email', with: re_user.email
          fill_in 'Password', with: 'pwd'
          fill_in 'Password confirmation', with: 'pwd'
          click_button 'SignUp'
          sleep 1
        
          expect(page).to have_content "Email has already been taken"
          expect(current_path).to eq users_path
        
          expect(User.all.size).to eq 1
        end
      end
    end
  end
 
    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          user = FactoryBot.create(:user)

          visit user_path(user)
          sleep 1
        
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end
 
  describe 'ログイン後' do
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          
          editing_user = FactoryBot.create(:user)
          # editing_user = FactoryBot.build(:user)ではDB上にレコード登録されていないのでログイン情報として使用不可

          # 編集するにはbefore_action :require_loginを通る必要がある

          login(editing_user)

          sleep 3
        
          visit edit_user_path(editing_user)
          sleep 1

          fill_in 'Email', with: editing_user.email
          fill_in "Password", with: 'edited_pwd'
          fill_in 'Password confirmation', with: 'edited_pwd'
        
          sleep 1

          click_button 'Update'

          sleep 1

          expect(page).to have_content 'User was successfully updated.'

          expect(current_path).to eq user_path(editing_user)
          # 編集前のユーザーファクトリをediting_user, 編集後のユーザーファクトリをedited_userと区別すると、idが異なってしまうため、詳細画面のパスエラー（ActionController::UrlGenerationError:No route matches）となる。区別する必要なし。

          sleep 1

        end
      end
    end
  end

      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do 
          user = FactoryBot.create(:user)
        
          login(user)
          
          visit edit_user_path(user)
          sleep 1
          
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
          user = FactoryBot.create(:user)
          re_user = FactoryBot.create(:re_user, email: 'hoge@example.com')
          
          login(re_user)
          
          visit edit_user_path(re_user)
          sleep 1
          
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'edited_pwd'
          fill_in 'Password confirmation', with: 'edited_pwd'
          click_button 'Update'
          sleep 1
          
          expect(page).to have_content "Email has already been taken"
          expect(current_path).to eq user_path(re_user)
        end
      end

      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          user = FactoryBot.create(:user)
          other_user = FactoryBot.create(:other_user)
      
          login(other_user)
          sleep 1

          visit edit_user_path(user)
          sleep 1

          expect(page).to have_content 'Forbidden access.'
          expect(current_path).to eq user_path(other_user)
        end
      end
 
    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          # ログインする
          login_user = FactoryBot.create(:user) # id=1のuser
          login(login_user)
          sleep 1

          # login_userが作成したタスクを用意
          task_by_login_user = FactoryBot.create(:task, user_id: 1)
    
          visit tasks_path
          sleep 1

          # ログインしたユーザーが作成したタスクが表示されているか
          expect(page).to have_content task_by_login_user.title
          expect(page).to have_content task_by_login_user.content
          expect(page).to have_content task_by_login_user.status
          expect(page).to have_content task_by_login_user.deadline.strftime('%Y/%-m/%-d %-H:%-M')
        end
      end
    end
  end
