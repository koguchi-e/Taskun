# frozen_string_literal: true

require 'rails_helper'

describe "ユーザーモデルのテスト" do
    it "エラーがなければ保存されているか" do
        expect(FactoryBot.build(:user)).to be_valid  
    end
end
