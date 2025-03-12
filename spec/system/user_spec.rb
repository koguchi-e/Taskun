# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "ログイン前のテスト" do
  let(:user){create(:user)}
  before do
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_button "ログイン"
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
    visit root_path
    save_and_open_page
  end
  
  context "ゲストログインボタンの表示" do
    it "ログインボタンが表示されているかどうか" do
      expect(page).to have_link "ゲストログイン（閲覧用）"
    end
  end
  context "ゲストログインの動作確認" do
    it "ゲストログインボタンをクリックするとログインできるかどうか" do
      click_link "ゲストログイン（閲覧用）"
      expect(page).to have_content "ゲストユーザーでログインしました。"
      guest_user = User.guest
      expect(page).to have_current_path users_path(guest_user)
    end
  end
end

describe "ユーザーのテスト" do
  before do
    sign_in user
  end

  let!(:task) { create(:task) }
  let(:user) { task.user }

  describe "一覧画面のテスト" do
    before do
      visit users_path
    end
    context "表示の確認" do
      it "ユーザーが表示されるかどうか" do
        expect(page).to have_content user.name
        expect(page).to have_link user.name
      end
    end
  end

  describe "詳細画面のテスト" do
    before do
      visit user_path(user)
    end
    context "表示の確認" do
      it "ユーザー情報が表示されているかどうか" do
        expect(page).to have_content user.name
        expect(page).to have_content user.email
        expect(page).to have_content task.title
      end
      it "編集リンクが存在するか" do
        expect(page).to have_selector("a[href='/users/#{user.id}/edit']")
      end
      it "退会リンクが存在するか" do
        expect(page).to have_link("退会", href: withdraw_user_path(user))
      end
    end
  end

  describe "編集画面のテスト" do
    before do
      visit edit_user_path(user)
    end
    context "表示の確認" do
      it "入力欄に編集前のユーザー名とメールアドレスがフォームに表示(セット)されている" do
        expect(page).to have_field "user[name]", with: user.name
        expect(page).to have_field "user[email]", with: user.email
      end
    end
    it "保存ボタンが表示される" do
      expect(page).to have_button "保存"
    end

    context "更新処理に関するテスト" do
      it "更新後リダイレクト先は正しいか" do
        within("form[action='#{user_path(user)}']") do
          fill_in "user[name]", with: Faker::Lorem.characters(number: 10)
          fill_in "user[email]", with: Faker::Lorem.characters(number: 10)
          click_button "保存"
        end
        expect(page).to have_current_path user_path(user)
      end
    end
  end
end
