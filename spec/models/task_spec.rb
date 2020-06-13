require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation check (presence:true)' do
    # タイトル(title)と状態(status)が入力されていればタスク登録できること
    it 'is valid with title, status' do
      task = build(:task, content: '', deadline: '')
      expect(task).to be_valid
      expect(task.errors[:title]).to be_empty
      expect(task.errors[:content]).to be_empty
    end
    
    # タイトルが未入力であれば、タスク登録できないこと
    it `is invalid without title` do
      task = build(:task, title: '')
      expect(task.valid?).to eq(false)
      expect(task.errors[:title]).to include("can't be blank")
    end
    
    # 状態が未入力であれば、タスク登録できないこと
    it `is invalid without status` do
      task = build(:task, status: '')
      expect(task.valid?).to eq(false)
      expect(task.errors[:status]).to include("can't be blank")
    end
  end
  
  describe 'validation check (uniqueness: true)' do
    # 登録済のタイトルと同じタイトルでタスク登録できないこと
    it 'is invalid with a duplicate task title' do
      task = create(:task)
      re_task = build(:task, title: task.title)
          
      expect(re_task.valid?).to eq(false)
      expect(re_task.errors[:title]).to include("has already been taken")
    end
  end
end
