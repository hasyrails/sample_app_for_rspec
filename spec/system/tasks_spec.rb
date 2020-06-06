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
end
