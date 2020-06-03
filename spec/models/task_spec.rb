require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
  # タイトル(title)と状態(status)が入力されていればタスク登録できること
    it 'is valid with title, status' do
      @task = FactoryBot.create(:task, content: '', deadline: '')
      expect(@task).to be_valid
    end
  end
end
