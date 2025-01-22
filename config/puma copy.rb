# 最大・最小スレッド数の設定
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# タイムアウト (開発環境のみ適用)
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# 環境に応じたバインド設定 (Windows ではポート、Unix ではソケットを使用)
if Gem.win_platform?
  # Windows 環境: ポートを使用
  port ENV.fetch("PORT") { 3000 }
else
  # Unix 環境: ソケットを使用
  bind "unix://#{Rails.root}/tmp/sockets/puma.sock"
end

# 環境を指定
environment ENV.fetch("RAILS_ENV") { "development" }

# PID ファイルの設定
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# 本番環境用の設定
rails_root = Dir.pwd
if Rails.env.production?
  pidfile File.join(rails_root, 'tmp', 'pids', 'puma.pid')
  state_path File.join(rails_root, 'tmp', 'pids', 'puma.state')
  stdout_redirect(
    File.join(rails_root, 'log', 'puma.log'),
    File.join(rails_root, 'log', 'puma-error.log'),
    true
  )
  # デーモンモード
  daemonize
end

# 再起動を有効化
plugin :tmp_restart
