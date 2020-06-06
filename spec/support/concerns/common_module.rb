require 'rails_helper'

shared_examples 'login success' do
  describe 'login success' do
    it 'can login' do
      # ログイン画面へ遷移
      visit login_path

      # ログイン情報を入力
      fill_in 'Email', with: editing_user.email
      fill_in 'Password', with: 'pwd'
      click_button 'Login'
      
    end
  end
end
