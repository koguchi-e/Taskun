# frozen_string_literal: true

require "rails_helper"

RSpec.describe "タスクのテスト" do
  let!(:task) { create(:task) }
  let(:user) { task.user }

  before do
    sign_in user
    visit tasks_path
  end

  describe "投稿機能のテスト" do
    context "表示の確認" do
      it "投稿ボタンがあるか" do
        expect(page).to have_selector(".submit-btn")
      end
    end

    context "投稿処理のテスト" do
      it "投稿後、詳細画面にリダイレクトする" do
        fill_in "task[title]", with: Faker::Lorem.characters(number: 10)
        fill_in "task[keyword1]", with: Faker::Lorem.characters(number: 10)
        fill_in "task[keyword2]", with: Faker::Lorem.characters(number: 10)
        fill_in "task[keyword3]", with: Faker::Lorem.characters(number: 10)
        find_button("投稿").click
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
      it "編集リンクが存在するか" do
        expect(page).to have_selector("a[href='/tasks/#{task.id}/edit']")
      end
      it "削除リンクが存在するか" do
        expect(page).to have_link("削除", href: task_path(task))
      end
    end
  end

  describe "編集画面のテスト" do
    before do
      visit edit_task_path(task)
    end

    context "表示の確認" do
      it "入力欄に編集前のタイトルとキーワードがフォームに表示(セット)されている" do
        expect(page).to have_field "task[title]", with: task.title
        expect(page).to have_field "task[keyword1]", with: task.keyword1
        expect(page).to have_field "task[keyword2]", with: task.keyword2
        expect(page).to have_field "task[keyword3]", with: task.keyword3
      end

      it "保存ボタンが表示される" do
        expect(page).to have_button "保存"
      end
    end

    context "更新処理に関するテスト" do
      it "更新後リダイレクト先は正しいか" do
        within("form[action='#{task_path(task)}']") do
          fill_in "task[title]", with: Faker::Lorem.characters(number: 10)
          fill_in "task[keyword1]", with: Faker::Lorem.characters(number: 10)
          fill_in "task[keyword2]", with: Faker::Lorem.characters(number: 10)
          fill_in "task[keyword3]", with: Faker::Lorem.characters(number: 10)
          click_button "保存"
        end
        expect(page).to have_current_path task_path(task)
      end
    end
  end
end
