require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe '#create' do
    context 'user registration' do
      it 'can be created' do
        new_user = FactoryBot.build(:user)

        visit new_user_path
        sleep 3

        fill_in 'Email', with: new_user.email
        fill_in "Password", with: 'pwd'
        # fill_in "Password", with: new_user.password では入力されない
        # sorceryでは「password」はvirtual attribute(DBに存在しない)→ActiveRecordメソッドで呼び出せない。
        fill_in 'Password confirmation', with: 'pwd'
        # fill_in "Password confirmation", with: new_user.password_confirmation では入力されない
        # sorceryでは「password_confirmation」はvirtual attribute(DBに存在しない)→ActiveRecordメソッドで呼び出せない。
        
        sleep 3

        click_button 'SignUp'

        sleep 3

        expect(page).to have_content 'User was successfully created.'
        expect(current_path).to eq login_path
      end
    end
  end
end
