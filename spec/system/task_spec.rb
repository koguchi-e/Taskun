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

describe "投稿一覧画面のテスト" do
    let(:user){create(:user)}
    let!(:task) {create(:task,title:"カリキュラムを5ページ進める", keyword1:"Ruby",keyword2:"テスト",keyword1:"エンジニア")}
    before do
        visit tasks_path
    end
    context "一覧画面のテスト" do 
        it "投稿されたものが表示されるかどうか" do
            expect(page).to have_content task.title
            expect(page).to have_link task.title
        end
    end
    context "新規投稿のテスト" do
        it "投稿ボタンがあるか" do
            expect(page).to have_selecter('button[type="submit-btn"]')
        end
    end
    context "投稿できるか" do
        it "投稿後、詳細画面にリダイレクトする" do
            fill_in "task[title]"
        end
    end
end


it "○○画面に○○画面のリンクが表示されているか" do
    expect(page).to have_link "", href: root_path
end
