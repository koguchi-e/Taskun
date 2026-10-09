# Taskunの開発用サンプルデータ

def create_user(email:, name:, image_filename:)
  User.find_or_create_by!(email: email) do |user|
    user.name = name
    user.password = SecureRandom.hex(6)
    user.image = ActiveStorage::Blob.create_and_upload!(
      io: File.open(Rails.root.join("db", "fixtures", image_filename)),
      filename: image_filename
    )
  end
end

def create_task(user:, title:, keyword1:, keyword2:, keyword3:)
  Task.find_or_create_by!(user: user, title: title) do |task|
    task.keyword1 = keyword1
    task.keyword2 = keyword2
    task.keyword3 = keyword3
  end
end

# Users
suzuki = create_user(email: "suzuki@test.com", name: "鈴木太郎", image_filename: "suzuki.png")
yamada = create_user(email: "yamada@test.com", name: "山田一郎", image_filename: "sample-user1.jpg")
tanaka = create_user(email: "tanaka@test.com", name: "田中花子", image_filename: "sample-user2.jpg")
satou = create_user(email: "satou@test.com", name: "佐藤次郎", image_filename: "sample-user3.jpg")

# Tasks
create_task(user: satou, title: "カリキュラム終わらせる", keyword1: "エンジニア", keyword2: "Ruby", keyword3: "勉強")
create_task(user: satou, title: "フロントの勉強する", keyword1: "エンジニア", keyword2: "転職活動", keyword3: "勉強")
create_task(user: satou, title: "GitHubの勉強する", keyword1: "エンジニア", keyword2: "転職活動", keyword3: "勉強")
create_task(user: yamada, title: "テスト勉強三時間する", keyword1: "学生", keyword2: "テスト", keyword3: "勉強")
create_task(user: yamada, title: "プログラミングスクールに入学", keyword1: "学生", keyword2: "就活", keyword3: "勉強")
create_task(user: tanaka, title: "ランニングを30分する", keyword1: "スポーツ", keyword2: "ランニング", keyword3: "運動")
create_task(user: tanaka, title: "次に読む本を決める", keyword1: "趣味", keyword2: "読書", keyword3: "リラックス")
ruby_task = create_task(user: suzuki, title: "Rubyの勉強する", keyword1: "エンジニア", keyword2: "Ruby", keyword3: "勉強")

# Task comments
TaskComment.find_or_create_by!(user: yamada, task: ruby_task, comment: "いいね！")
TaskComment.find_or_create_by!(user: tanaka, task: ruby_task, comment: "頑張ってますね！")

# Groups
Group.find_or_create_by!(name: "エンジニア勉強の会（東京）") do |group|
  group.summary = "東京でエンジニアとして勉強しているメンバーを募集しています。毎週金曜日20時から勉強会を開催しています。"
  group.image = ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db", "fixtures", "group1.png")),
    filename: "group1.png"
  )
  group.owner = suzuki
  group.members << satou
  group.members << yamada
end

Group.find_or_create_by!(name: "週末スポーツの会") do |group|
  group.summary = "ランニングや軽い運動を一緒に楽しむメンバーを募集しています。初心者でも参加しやすいグループです。"
  group.owner = tanaka
  group.members << suzuki
  group.members << yamada
end
