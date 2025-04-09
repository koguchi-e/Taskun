# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

yamada = User.find_or_create_by!(email: "yamada@test.com") do |user|
  user.name = "山田"
  user.password = SecureRandom.hex(6)
  user.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename: "sample-user1.jpg")
end

tanaka = User.find_or_create_by!(email: "tanaka@test.com") do |user|
  user.name = "田中"
  user.password = SecureRandom.hex(6)
  user.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename: "sample-user2.jpg")
end

satou = User.find_or_create_by!(email: "satou@test.com") do |user|
  user.name = "佐藤"
  user.password = SecureRandom.hex(6)
  user.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg"), filename: "sample-user3.jpg")
end

Task.find_or_create_by!(user: satou, title: "Rubyの勉強する") do |task|
  task.keyword1 = "エンジニア"
  task.keyword2 = "Ruby"
  task.keyword3 = "勉強"
end

Task.find_or_create_by!(user: satou, title: "カリキュラム終わらせる") do |task|
  task.keyword1 = "エンジニア"
  task.keyword2 = "Ruby"
  task.keyword3 = "勉強"
end

Task.find_or_create_by!(user: satou, title: "フロントの勉強する") do |task|
  task.keyword1 = "エンジニア"
  task.keyword2 = "転職活動"
  task.keyword3 = "勉強"
end

Task.find_or_create_by!(user: satou, title: "GitHubの勉強する") do |task|
  task.keyword1 = "エンジニア"
  task.keyword2 = "転職活動"
  task.keyword3 = "勉強"
end

Task.find_or_create_by!(user: yamada, title: "テスト勉強三時間する") do |task|
  task.keyword1 = "学生"
  task.keyword2 = "テスト"
  task.keyword3 = "勉強"
end

Task.find_or_create_by!(user: yamada, title: "プログラミングスクールに入学") do |task|
  task.keyword1 = "学生"
  task.keyword2 = "就活"
  task.keyword3 = "勉強"
end

Task.find_or_create_by!(user: tanaka, title: "洗濯をする") do |task|
  task.keyword1 = "家事"
  task.keyword2 = "主婦"
  task.keyword3 = "家庭"
end

Task.find_or_create_by!(user: tanaka, title: "ゴミを出す") do |task|
  task.keyword1 = "家事"
  task.keyword2 = "主婦"
  task.keyword3 = "家庭"
end

TaskComment.find_or_create_by!(user: yamada, comment: "いいね！") do |task_comment|
  task_comment.task = Task.find_by(title: "Rubyの勉強する")
end

TaskComment.find_or_create_by!(user: tanaka, comment: "頑張ってますね！") do |task_comment|
  task_comment.task = Task.find_by(title: "Rubyの勉強する")
end

Group.find_or_create_by!(name: "エンジニア勉強の会（東京）") do |group|
  group.summary =  "東京でエンジニアとして勉強してるメンバーを募集しています。毎週金曜日20時から勉強会を開催しています。"
  group.owner = User.find_by(name: "テスト太郎")
  group.members << User.find_by(name: "山田")
  group.members << User.find_by(name: "佐藤")
end

Group.find_or_create_by!(name: "家事やるぞ！") do |group|
  group.summary =  "主婦でも1人暮らしの方でも！みんなで苦手な家事にトライ！"
  group.owner = User.find_by(name: "田中")
  group.members << User.find_by(name: "山田")
end
