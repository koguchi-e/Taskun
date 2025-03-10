# frozen_string_literal: true

require 'rails_helper'

Rspec.describe "ログイン前のテスト" do
    let(:user){create(:user)}

    before do
        visit new_user_session_path
        fill_in "user_email", with: user.user_email
        fill_in "user_password", with: user.password
        click_button "login-btn"
        visit root_path
    end

    context "表示の確認" do
        it "root_pathが/であるか" do
            expect(current_path).to eq("/")
        end
    end
end

describe "ゲストログインのテスト" do
    before do 
        visit new_user_session_path
    end
    context "ゲストログインボタンの表示" do
        it "ログインボタンが表示されているかどうか" do
            expect(page).to have_link "ゲストログイン", href: "users/guest_sign_in"
        end
    end
    context "ゲストログインの動作確認" do
        it "ゲストログインボタンをクリックするとログインできるかどうか" do
            click_link "guest_login_user"
            expect(pave).to have_link users_path
        end
    end
end

describe "タスクのテスト" do
    let(:user){create(:user)}
    let!(:task) {create(:task,title:"カリキュラムを5ページ進める", keyword1:"Ruby",keyword2:"テスト",keyword1:"エンジニア")}
    before do
        visit task_path
    end
    describe "投稿機能のテスト" do
        context "表示の確認" do
            it "投稿ボタンがあるか" do
                expect(page).to have_selecter('button[type="submit-btn"]')
            end
        end
        context "投稿処理のテスト" do
            it "投稿後、詳細画面にリダイレクトする" do
                fill_in "task[title]", with: Faker::Lorem.characters(number:10)
                fill_in "task[keyword1]", with: Faker::Lorem.characters(number:10)
                fill_in "task[keyword2]", with: Faker::Lorem.characters(number:10)
                fill_in "task[keyword3]", with: Faker::Lorem.characters(number:10)
                click_button "投稿"
                expect(page).to have_current_path task_path(Task.last)
            end
        end
    end
    
    describe "一覧画面のテスト" do
        context "表示の確認" do 
            it "投稿されたものが表示されるかどうか" do
                expect(page).to have_content task.title
                expect(page).to have_link task.title
            end
        end
    end
    
    describe "詳細画面のテスト" do
        before do 
            visit task_path(task)
        end
        context "表示の確認" do
            it "削除リンクが存在するか" do
                expect(page).to  have_selector("a[href='/tasks/#{task.id}][data-method='delete']")
            end
            it "編集リンクが存在するか" do
                expect(page).to have_selector("a[href='/tasks/#{task.id}/edit']")
            end
        end
    end

    describe "編集画面のテスト" do
        let!(:user){create(:user)}
        let!(:task){create(:task,title:"カリキュラムを5ページ進める", keyword1:"Ruby",keyword2:"テスト",keyword1:"エンジニア")}
        context "表示の確認" do
            before do
                sign_in user
                visit edit_task_path(task)
            end
            it "入力欄に編集前のタイトルとキーワードがフォームに表示(セット)されている" do
                expect(page).to have_field "task[title]", with: task.title
                expect(page).to  have_field "task[keyword1]", with: task.keyword1
                expect(page).to  have_field "task[keyword2]", with: task.keyword2
                expect(page).to  have_field "task[keyword3]", with: task.keyword3
            end
            it "保存ボタンが表示される " do
                expect(page).to have_button "保存"
            end
        end
        context "更新処理に関するテスト" do
            it "更新後リダイレクト先は正しいか" do
                fill_in "task[title]", with: Faker::Lorem.characters(number:10)
                fill_in "task[keyword1]", with: Faker::Lorem.characters(number:10)
                fill_in "task[keyword2]", with: Faker::Lorem.characters(number:10)
                fill_in "task[keyword3]", with: Faker::Lorem.characters(number:10)
                click_button "保存"
                expect(task).to have_current_path task_path(task)
            end
        end
    end
    
    
end


it "○○画面に○○画面のリンクが表示されているか" do
    expect(page).to have_link "", href: root_path
end
