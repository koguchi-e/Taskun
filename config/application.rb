require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Portfolio
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end

# エラーメッセージを日本語にするため追加
require_relative "boot"
require "rails/all"
Bundler.require(*Rails.groups)

module Taskun
  class Application < Rails::Application
    # アプリケーション全体の設定をここに記述します。
    # デフォルトのロケールを日本語に設定
    config.i18n.default_locale = :ja
  end
end

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
