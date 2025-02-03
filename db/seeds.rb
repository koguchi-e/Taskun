# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

olivia = User.find_or_create_by!(email: "olivia@example.com") do |user|
  user.name = "Olivia"
  user.password = "password"
  user.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename:"sample-user1.jpg")
end

james = User.find_or_create_by!(email: "james@example.com") do |user|
  user.name = "James"
  user.password = "password"
  user.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename:"sample-user2.jpg")
end

lucas = User.find_or_create_by!(email: "lucas@example.com") do |user|
  user.name = "Lucas"
  user.password = "password"
  user.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg"), filename:"sample-user3.jpg")
end

Task.find_or_create_by!(user_id: 2) do |task|
  task.title = "テスト勉強三時間する"
  task.user = olivia
  task.keyword1 = "学生"
  task.keyword2 = "テスト"
  task.keyword3 = "勉強"
end

Task.find_or_create_by!(user_id: 3) do |task|
  task.title = "洗濯をする"
  task.user = james
  task.keyword1 = "家事"
  task.keyword2 = "主婦"
  task.keyword3 = "家庭"
end

Task.find_or_create_by!(user_id: 4) do |task|
  task.title = 'カリキュラム終わらせる'
  task.user = lucas
  task.keyword1 = "テスト"
  task.keyword2 = "Ruby"
  task.keyword3 = "勉強"
end
