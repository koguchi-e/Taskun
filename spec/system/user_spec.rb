# frozen_string_literal: true

require "rails_helper"

RSpec.describe "トップページについて" do
  let(:user_attributes) { attributes_for(:user) }

  context "URLの確認" do
    it "root_pathが/であるか" do
      visit root_path
      expect(current_path).to eq("/")
    end
  end

  context "ログインの入力情報が正しい場合" do
    let(:user) { create(:user) }

    it "ユーザー詳細ページに遷移するか" do
      visit new_user_session_path
      fill_in "user_email", with: user.email
      fill_in "user_password", with: user.password
      click_button "ログイン"

      expect(page).to have_current_path(user_path(user))
      expect(page).to have_content "ログインしました。"
    end
  end

  context "新規登録の動作について" do
    context "表示の確認" do
      it "入力フォームが正しく表示されているか" do
        visit new_user_registration_path
        expect(page).to have_field("user[name]")
        expect(page).to have_field("user[email]")
        expect(page).to have_field("user[password]")
        expect(page).to have_field("user[password_confirmation]")
        expect(page).to have_button("登録")
      end
    end

    context "新規登録処理について" do
      it "正しい情報の場合、新規登録が完了する" do
        visit new_user_registration_path
        fill_in "user_name", with: user_attributes[:name]
        fill_in "user_email", with: user_attributes[:email]
        fill_in "user_password", with: user_attributes[:password]
        fill_in "user_password_confirmation", with: user_attributes[:password]
        click_button "登録"

        expect(page).to have_content "アカウント登録が完了しました。"
      end
      it "誤った情報の場合、登録が失敗する" do
        visit new_user_registration_path

        fill_in "user_name", with: ""
        fill_in "user_email", with: ""
        fill_in "user_password", with: ""
        fill_in "user_password_confirmation", with: ""

        expect { click_button "登録" }.not_to change(User, :count)
        expect(page).to have_content "件のエラーが発生しました。"
      end
    end
  end
end

describe "ゲストログインについて" do
  before do
    visit root_path
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

describe "ユーザーについて" do
  before do
    sign_in user
  end

  let!(:task) { create(:task) }
  let(:user) { task.user }

  describe "一覧画面について" do
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

  describe "詳細画面について" do
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

  describe "編集画面について" do
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

    context "更新処理に関するについて" do
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
