require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe '#create' do
    context 'user registration' do
      it 'can be created' do
        new_user = FactoryBot.create(:user)

        visit new_user_path
      end
    end
  end
end
