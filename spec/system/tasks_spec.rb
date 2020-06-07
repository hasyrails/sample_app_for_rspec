require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  describe '#create' do
    it 'can create a new task' do
      # ログインする
      user = FactoryBot.create(:user)
      login(user)
      sleep 1

      visit new_task_path

      task = FactoryBot.build(:task)
      fill_in 'Title', with: task.title
      select task.status, from: 'Status'
      click_button 'Create Task'
      
      expect(page).to have_content 'Task was successfully created.'
      
      expect(current_path).to eq task_path(task)
      # ActionController::UrlGenerationError:
      # No route matches {:action=>"show", :controller=>"tasks", :id=>nil}, missing required keys: [:id]
    end
  end

  describe '#edit' do
    it 'can edit a new task' do
      # ログインする ===
      user = FactoryBot.create(:user)
      login(user)
      sleep 1
      # ===

      # タスクを新規作成 ===
      visit new_task_path
      
      task = FactoryBot.build(:task)
      fill_in 'Title', with: task.title
      select task.status, from: 'Status'
      click_button 'Create Task'
      # =====
      
      # 新規作成したタスクを編集 ===
      visit edit_task_path(task)
      
      fill_in 'Title', with: 'ピアノ'
      select task.status, from: 'Status'
      sleep 1
      click_button 'Update Task'
      
      expect(page).to have_content 'Task was successfully updated.'
      
      expect(current_path).to eq task_path(task)
      # ===
    end
  end
  
  describe '#destroy' do
    it 'can be deleted' do
      # ログインする ===
      user = FactoryBot.create(:user)
      login(user)
      sleep 1
      # ===
    
      # タスクを新規作成 ===
      visit new_task_path
      
      task = FactoryBot.build(:task)
      fill_in 'Title', with: task.title
      select task.status, from: 'Status'
      click_button 'Create Task'
      # =====
      
      # 新規作成したタスクを削除 ===
      visit root_path
      
      click_link 'Destroy'

      expect {
        page.accept_confirm "Are you sure?"
        expect(page).to have_content "Task was successfully destroyed."
      }.to change { Task.count }.by(-1)

      expect(page).to have_content 'Task was successfully destroyed.'
      
      expect(current_path).to eq tasks_path
      # ===
    end
  end
end

# ※task編集成功のテストコードに関して
# task = FactoryBot.create(:task) で作成したタスクを編集することとすると、user_idが一致しないユーザーがアクセスすることとなるため、アクセスできない。
# taskファクトリにuser_idを指定したら可か？
# ====
# task = FactoryBot.create(:task)      
# visit edit_task_path(task)
# fill_in 'Title', with: 'ピアノ'
# select task.status, from: 'Status'
# sleep 1
# click_button 'Update Task'    
# ===
