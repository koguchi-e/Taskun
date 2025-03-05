# frozen_string_literal: true

require 'rails_helper'

descirbe "タスクモデルのテスト" do
    it "エラーがなければ保存されているか" do
        expect(Factory.Bot.build(:task)).to be_valid  
    end
end
