require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  describe 'ユーザーのログイン/ログアウト' do 
    let(:user) { create(:user) }
    describe 'ログイン前' do
      before do
        # let!(:user) { create(:user) }
        visit login_path
        sleep 1
      end
      context 'フォームの入力値が正常' do
        it 'ログイン処理が成功する' do
          
          # post '/login', params: { user: FactoryBot.attributes_for(:user) }
          # post :create, params: { user: FactoryBot.attributes_for(:user) }
          # No match routesエラーが起こる
          
          # follow_redirect!
          # not a redirectエラー
          
          login(user)
          sleep 1
          expect(page).to have_content 'Login successful'
          expect(current_path).to eq root_path
        end
      end

      context 'フォームが未入力' do
        it 'ログイン処理が失敗する' do
          fill_in 'email', with: ''
          sleep 3
          fill_in 'Password', with: 'pwd'
          click_button 'Login'
          expect(page).to have_content 'Login failed'
          expect(current_path).to eq login_path
        end
      end
    end
    
    describe 'ログイン後' do
      # before do
        # user = FactoryBot.create(:user)
        
        # login(user)
      # end
      before do
        login(user)
      end
      context 'ログアウトボタンをクリック' do
        it 'ログアウト処理が成功する' do 
          
          click_on 'Logout'
          sleep 1

          expect(page).to have_content 'Logged out'
          expect(current_path).to eq root_path
          sleep 1
        end
      end
    end
  end
end
