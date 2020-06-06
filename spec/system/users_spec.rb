require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe '#create' do
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
  
  describe '#edit' do
    context 'editing user' do
      it 'can be edited' do

        editing_user = FactoryBot.create(:user)
        edited_user = FactoryBot.build(:edited_user)

        visit login_path
        fill_in 'Email', with: editing_user.email
        fill_in 'Password', with: 'pwd'
        click_button 'Login'
        sleep 3
        visit edit_user_path(editing_user)
        sleep 1

        fill_in 'Email', with: edited_user.email
        fill_in "Password", with: 'edited_pwd'
        fill_in 'Password confirmation', with: 'edited_pwd'
        
        sleep 1

        click_button 'Update'

        sleep 1

        expect(page).to have_content 'User was successfully updated.'
        expect(current_path).to eq user_path(editing_user)

        sleep 1
      end
    end
  end
end
