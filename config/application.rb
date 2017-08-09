require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SuorademokratiaNet
  class Application < Rails::Application
    config.load_defaults 5.1

    config.i18n.default_locale = :fi
    config.i18n.available_locales = [:fi, :en]
    
    routes.default_url_options = { host: 'suorademokratia.jonitoyryla.eu' }

    config.cache_store = :redis_store, "redis://localhost:6379/0/cache", { expires_in: 90.minutes }
    
  end
end
