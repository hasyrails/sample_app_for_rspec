require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  describe 'ログイン前' do
    context 'フォームの入力値が正常' do
      it 'ログイン処理が成功する' do
        login_user = FactoryBot.create(:user)
        
        visit login_path
        sleep 1
        
        login(login_user)
        sleep 1
        
        # post '/login', params: { user: FactoryBot.attributes_for(:user) }
        # post :create, params: { user: FactoryBot.attributes_for(:user) }
        # No match routesエラーが起こる
        
        # follow_redirect!
        # not a redirectエラー
        
        expect(page).to have_content 'Login successful'
        expect(current_path).to eq root_path
      end
    end

    context 'フォームが未入力' do
      it 'ログイン処理が失敗する' do
        user = FactoryBot.create(:user)
        
        visit login_path
        sleep 1
        
        fill_in 'Email', with: ''
        fill_in 'Password', with: 'pwd'
        click_button 'Login'
        expect(page).to have_content 'Login failed'
        expect(current_path).to eq login_path
      end
    end
  end
  
  describe 'ログイン後' do
    context 'ログアウトボタンをクリック' do
      it 'ログアウト処理が成功する' do 
        user = FactoryBot.create(:user)
        
        login(user)
        
        click_link 'Logout'
        sleep 1

        expect(page).to have_content 'Logged out'
        expect(current_path).to eq root_path
        sleep 1
      end
    end
  end
end
