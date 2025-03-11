# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "ユーザーのテスト" do

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