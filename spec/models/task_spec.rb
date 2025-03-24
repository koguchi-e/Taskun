# frozen_string_literal: true

require "rails_helper"

describe "タスクモデルのテスト" do
  it "エラーがなければ保存されているか" do
    expect(FactoryBot.build(:task)).to be_valid
  end
end
