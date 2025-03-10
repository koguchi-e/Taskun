# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "ログイン前のテスト" do
    let(:user){create(:user)}

    before do
        visit new_user_session_path
        fill_in "user_email", with: user.email
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
