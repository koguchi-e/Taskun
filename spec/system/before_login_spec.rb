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
                expect(page).to have_link(href: login_path)
            end
        end
    end


    
    
end
