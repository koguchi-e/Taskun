# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

test_tarou = User.find_or_create_by!(email: "aaa@gmail.com") do |user|
  user.name = "テスト太郎"
  user.password = "123456"
  user.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/test-tarou.jpg"), filename:"test-tarou.jpg")
end

yamada = User.find_or_create_by!(email: "yamada@example.com") do |user|
  user.name = "山田"
  user.password = "123456"
  user.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename:"sample-user1.jpg")
end

tanaka = User.find_or_create_by!(email: "tanaka@example.com") do |user|
  user.name = "田中"
  user.password = "123456"
  user.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename:"sample-user2.jpg")
end

satou = User.find_or_create_by!(email: "satou@example.com") do |user|
  user.name = "佐藤"
  user.password = "123456"
  user.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg"), filename:"sample-user3.jpg")
end

Task.find_or_create_by!(user: test_tarou, title: 'Rubyの勉強する') do |task|
  task.keyword1 = "テスト"
  task.keyword2 = "Ruby"
  task.keyword3 = "勉強"
end

Task.find_or_create_by!(user: yamada, title: "テスト勉強三時間する") do |task|
  task.keyword1 = "学生"
  task.keyword2 = "テスト"
  task.keyword3 = "勉強"
end

Task.find_or_create_by!(user: tanaka, title: "洗濯をする") do |task|
  task.keyword1 = "家事"
  task.keyword2 = "主婦"
  task.keyword3 = "家庭"
end

Task.find_or_create_by!(user: satou, title: 'カリキュラム終わらせる') do |task|
  task.keyword1 = "テスト"
  task.keyword2 = "Ruby"
  task.keyword3 = "勉強"
end

3.times do
  Task.find_or_create_by!(user: test_tarou, title: '勉強する') do |task|
    task.keyword1 = "テスト"
    task.keyword2 = "Ruby"
    task.keyword3 = "勉強"
  end
end
