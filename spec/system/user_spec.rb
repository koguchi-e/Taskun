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
    end
    
    context "ゲストログインボタンの表示" do
        it "ログインボタンが表示されているかどうか" do
            expect(page).to have_link "ゲストログイン（閲覧用）"
        end
    end
    context "ゲストログインの動作確認" do
        let(:user) { create(:user, :guest) } 
        it "ゲストログインボタンをクリックするとログインできるかどうか" do
            click_link "ゲストログイン（閲覧用）"
            expect(page).to have_content "ゲストユーザーでログインしました。"
            expect(page).to have_link user_path(user)
        end
    end
end

describe "ユーザーのテスト" do
  let(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create(:task, user: user, title: "カリキュラムを5ページ進める", keyword1: "Ruby", keyword2: "テスト", keyword3: "エンジニア") }

  before do
    sign_in user
    visit users_path
  end

  describe "一覧画面のテスト" do
    let(:user) { FactoryBot.create(:user) }

    context "表示の確認" do
      it "ユーザーが表示されるかどうか" do
        expect(page).to have_content user.name
        expect(page).to have_link user.name
      end
    end
  end
end
