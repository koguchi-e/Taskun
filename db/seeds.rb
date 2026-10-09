# Taskunの開発用サンプルデータ

def create_sample_image_blob(image_filename)
  image_path = Rails.root.join("db", "fixtures", image_filename)

  File.open(image_path) do |file|
    ActiveStorage::Blob.create_and_upload!(
      io: file,
      filename: image_filename,
      content_type: Marcel::MimeType.for(image_path),
      identify: false,
      metadata: { analyzed: true }
    )
  end
end

def create_user(email:, name:, image_filename:)
  User.find_or_create_by!(email: email) do |user|
    user.name = name
    user.password = SecureRandom.hex(6)
    user.image = create_sample_image_blob(image_filename)
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

# 旧サンプルデータを置き換える
Task.where(user: tanaka, title: ["洗濯をする", "ゴミを出す"]).destroy_all
Group.find_by(name: "家事やるぞ！", owner: tanaka)&.destroy!

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
tokyo_group = Group.find_or_initialize_by(name: "エンジニア勉強の会（東京）")
tokyo_group.summary = "東京でエンジニアとして勉強しているメンバーを募集しています。毎週金曜日20時から勉強会を開催しています。"
tokyo_group.owner = suzuki
tokyo_group.save!

unless tokyo_group.image.attached?
  tokyo_group.image = create_sample_image_blob("group1.png")
  tokyo_group.save!
end

GroupMembership.find_or_create_by!(group: tokyo_group, user: satou)
GroupMembership.find_or_create_by!(group: tokyo_group, user: yamada)

weekend_sports_group = Group.find_or_initialize_by(name: "週末スポーツの会")
weekend_sports_group.summary = "ランニングや軽い運動を一緒に楽しむメンバーを募集しています。初心者でも参加しやすいグループです。"
weekend_sports_group.owner = tanaka
weekend_sports_group.save!

GroupMembership.find_or_create_by!(group: weekend_sports_group, user: suzuki)
GroupMembership.find_or_create_by!(group: weekend_sports_group, user: yamada)
