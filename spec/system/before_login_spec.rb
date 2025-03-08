# frozen_string_literal: true

require 'rails_helper'

describe "ログイン前のテスト" do
    describe "トップページのテスト" do
        before do
            visit root_path
        end

        content "表示内容の確認" do
            it "root_pathのURLが「/」であるか" do
                expect(current_path).to eq("/")
            end
            it "ログインのリンクがあるか" do
                expect(page).to have_link(href: sign_in)
            end
            it "新規登録のリンクがあるか" do
                expect(page).to have_link(href: sign_up)
            end
        end
    end

    describe "ログイン前・ナビゲーションのテスト" do
        before do
            visit root_path
        end

        context "表示内容の確認" do
            it "左から1番目がトップページリンク" do
                home_link = find_all("a")[0].text
                expect(home_link).to match "(/Taskun./)"
            end
            it "左から2番目がアバウトページ" do
                home_link = find_all("a")[1].text
                expect(home_link).to match(about)
            end

        end
    end
    it "左から2番目がログイン中ユーザーの詳細ページ" do
        home_link = find
    end
end
