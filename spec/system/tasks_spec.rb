require 'rails_helper'

RSpec.describe 'Tasks', type: :system do  
  describe 'ログイン前' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:task) { create(:task) }
    let(:other_task) { create(:task, user_id: other_user.id) }
    
    #==require_loginによるアクセス制限を検証==
    describe 'ページ遷移(require_login)' do

    #==require_loginでアクセスできないことを検証==
      # before_action :require_login, only: %i[new edit]
      context 'タスク新規作成ページへアクセス' do     
        it 'タスク新規作成ページに遷移できない' do
          visit new_task_path
          sleep 1
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
          sleep 1
        end
      end
      
      context 'タスク編集ページへアクセス' do
        it 'タスク編集ページに遷移できない' do
          visit edit_task_path(task)
          sleep 1
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
          sleep 1
        end
      end
      
    #==require_login対象外でアクセスできることを検証==
      # before_action :require_login, only: %i[new edit]
      context 'タスク詳細ページへアクセス' do
        it 'タスク詳細ページに遷移できる' do
          visit task_path(task)
          sleep 1
          expect(current_path).to eq task_path(task)
          expect(page).to have_content task.title
          expect(page).to have_content task.content
          expect(page).to have_content task.status
          expect(page).to have_content task.deadline.strftime('%Y/%-m/%-d %-H:%-M')
          sleep 1
        end
      end
      
      context 'タスク一覧ページへアクセス' do
        it 'タスク一覧ページに遷移できる' do
          task 
          other_task
          # letでcreateしたtaskを呼び出す必要あり。

          visit tasks_path

          expect(page).to have_content task.title
          expect(page).to have_content task.content
          expect(page).to have_content task.status
          expect(page).to have_content task.deadline.strftime('%Y/%-m/%-d %-H:%-M')

          expect(page).to have_content other_task.title
          expect(page).to have_content other_task.content
          expect(page).to have_content other_task.status
          expect(page).to have_content other_task.deadline.strftime('%Y/%-m/%-d %-H:%-M')
        end
      end
    end
    
  
  describe 'ログイン後' do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:task) { build(:task) }
  let(:edit_task) {create(:task)}
  let(:task_duplicated_title) { create(:task, title: task.title) }
  let(:other_task) { create(:task, user_id: other_user.id) }
    before do
      login(user)
    end
    
      describe 'タスク新規作成' do
      before do
        visit new_task_path
        sleep 1
      end

        context 'フォームの入力値が正常' do
          it 'タスク新規作成が成功する' do
            fill_in 'Title', with: task.title
            fill_in 'Content', with: task.content
            select task.status, from: 'task_status'
            fill_in 'Deadline', with: task.deadline
            sleep 1
            
            click_button 'Create Task'
            sleep 1

            expect(page).to have_content 'Task was successfully created.'
            expect(current_path).to eq '/tasks/1'
            sleep 1
          end
        end

        context 'タスクのタイトルが未入力' do
          it 'タスク新規作成が失敗する' do
            fill_in 'Title', with: ''
            fill_in 'Content', with: task.content
            select task.status, from: 'task_status'
            fill_in 'Deadline', with: task.deadline
            sleep 1
            
            click_button 'Create Task'
            sleep 1

            expect(page).to have_content "Title can't be blank"
            expect(current_path).to eq tasks_path
            sleep 1
          end
        end

        context '登録済のタイトルを入力' do
          it 'タスク新規作成が失敗する' do
            task_duplicated_title
            fill_in 'Title', with: task.title
            fill_in 'Content', with: task.content
            select task.status, from: 'task_status'
            fill_in 'Deadline', with: task.deadline
            sleep 1
            
            click_button 'Create Task'
            sleep 1

            expect(page).to have_content "Title has already been taken"
            expect(current_path).to eq tasks_path
            sleep 1
          end
        end
      end
        
        describe 'タスク編集' do
          before do
            task = create(:task, user_id: user.id)
            visit edit_task_path(task)
            sleep 1
          end
          
          context 'フォームの入力値が正常' do
            it 'タスクの編集が成功する' do
              fill_in 'Title', with: 'Title edited'
              fill_in 'Content', with: task.content
              select task.status, from: 'task_status'
              fill_in 'Deadline', with: task.deadline.strftime('%Y/%-m/%-d %-H:%-M')
              sleep 1
              
              click_button 'Update'
              sleep 1
              
              expect(page).to have_content 'Task was successfully updated.'
              expect(current_path).to eq task_path(user)
              sleep 1
            end
          end

          context 'タスクのタイトルが未入力' do
            it 'タスクの編集が失敗する' do
              fill_in 'Title', with: ''
              fill_in 'Content', with: task.content
              select task.status, from: 'task_status'
              fill_in 'Deadline', with: task.deadline
              sleep 1
              
              click_button 'Update Task'
              sleep 1
              
              expect(page).to have_content "Title can't be blank"
              expect(current_path).to eq task_path(user)
              sleep 1
            end
          end
          
          context '登録済のタイトルを使用' do
            it 'タスクの編集が失敗する' do
              fill_in 'Title', with: task_duplicated_title.title
              sleep 1
              
              click_on 'Update Task'
              sleep 1
              
              expect(page).to have_content "Title has already been taken"
              expect(current_path).to eq task_path(user)
              sleep 1
            end
          end

        describe 'タスクの削除' do
          context 'タスク一覧画面で' do 
            it 'タスクの削除に成功する' do
              visit tasks_path
              click_on 'Destroy', match: :first
              expect {
                page.accept_confirm "Are you sure?"
                expect(page).to have_content "Task was successfully destroyed."
              }.to change { Task.count }.by(-1)
            end
          end
          context 'マイページで' do
            it 'タスクの削除に成功する' do
              visit user_path(user)
              click_on 'Destroy', match: :first
              expect {
                page.accept_confirm "Are you sure?"
                expect(page).to have_content "Task was successfully destroyed."
              }.to change { Task.count }.by(-1)
            end
          end
        end

        describe 'タスクの削除' do
          context 'タスク一覧画面で' do 
            it 'タスクの削除に成功する' do
              visit tasks_path
              click_on 'Destroy', match: :first
              expect {
                page.accept_confirm "Are you sure?"
                expect(page).to have_content "Task was successfully destroyed."
              }.to change { Task.count }.by(-1)
            end
          end
          context 'マイページで' do
            it 'タスクの削除に成功する' do
              visit user_path(user)
              click_on 'Destroy', match: :first
              expect {
                page.accept_confirm "Are you sure?"
                expect(page).to have_content "Task was successfully destroyed."
              }.to change { Task.count }.by(-1)
            end
          end
        end

        describe '他のユーザーが作成したタスクの操作' do
          context '他のユーザーが作成したタスクの詳細ページにアクセス' do
            it 'アクセスに失敗する' do
            # verify_accessメソッドの検証
                visit edit_task_path(other_task)
                sleep 1
                
                expect(page).to have_content 'Forbidden access.'
                expect(current_path).to eq root_path
                sleep 1
            end
          end
        end
      end
    end
  end
end
