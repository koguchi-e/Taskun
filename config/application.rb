require_relative "boot"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Taskun
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # デフォルトのロケールを日本語に設定
    # config.i18n.default_locale = :en
    config.i18n.default_locale = :ja

    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}").to_s]

    # `full_messages` の仕様を変更して、二重表示を防ぐ
    # config.active_model.i18n_customize_full_message = true

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end

# 文字コードの設定（必要なら残す）
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
