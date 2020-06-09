require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'UsersController#create' do
    context 'user registration' do
      it 'can be created' do
        new_user = FactoryBot.build(:user)

        visit new_user_path
        sleep 1

        fill_in 'Email', with: new_user.email
        fill_in "Password", with: 'pwd'
        # fill_in "Password", with: new_user.password では入力されない
        # sorceryでは「password」はvirtual attribute(DBに存在しない)→ActiveRecordメソッドで呼び出せない。
        fill_in 'Password confirmation', with: 'pwd'
        # fill_in "Password confirmation", with: new_user.password_confirmation では入力されない
        # sorceryでは「password_confirmation」はvirtual attribute(DBに存在しない)→ActiveRecordメソッドで呼び出せない。
        
        sleep 1

        click_button 'SignUp'

        sleep 1

        expect(page).to have_content 'User was successfully created.'
        expect(current_path).to eq login_path
      end
    end
  end
  
  describe 'UsersController#edit' do
    context 'editing user' do
      it 'can be edited' do

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

  describe 'login' do
    context 'login success' do
      it 'can login' do
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
  end
end
