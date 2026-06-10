require_relative "boot"
require "rails/all"
require_relative "../lib/fizzy"
require_relative "../lib/action_pack/railtie"

# The passkey railtie reopens ActionPack::Passkey from its on_load hooks (e.g.
# require_relative "passkey/request") and relies on the base class
# (lib/action_pack/passkey.rb) already being defined. ActionPack is the actionpack
# gem's namespace, so Zeitwerk doesn't autoload it for us; normally eager-load
# defines it in time, but our omniauth gems reorder the initializer chain so the
# hooks can run first. Register an explicit autoload so any reference resolves the
# base class regardless of boot order.
ActionPack.autoload :Passkey, File.expand_path("../lib/action_pack/passkey.rb", __dir__)

Bundler.require(*Rails.groups)

module Fizzy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Include the `lib` directory in autoload paths. Use the `ignore:` option
    # to list subdirectories that don't contain `.rb` files or that shouldn't
    # be reloaded or eager loaded.
    config.autoload_lib ignore: %w[ assets tasks rails_ext ]

    # Enable debug mode for Rails event logging so we get SQL query logs.
    # This was made necessary by the change in https://github.com/rails/rails/pull/55900
    config.after_initialize do
      Rails.event.debug_mode = true
    end

    # Use UUID primary keys for all new tables
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    config.action_pack.passkey.draw_routes = false
    config.action_pack.passkey.challenge_url = -> { my_passkey_challenge_path(script_name: "") }

    # Subclass ActiveRecord::Base directly rather than our ApplicationRecord. The
    # passkey base class can load very early (see the autoload above), before
    # Zeitwerk can resolve the app-level ApplicationRecord, which would raise at
    # boot. Fizzy authenticates via Google SSO and never writes passkeys, so the
    # ApplicationRecord behaviours (UUID generation, replica connections) are moot.
    config.action_pack.passkey.parent_class_name = "ActiveRecord::Base"

    config.mission_control.jobs.http_basic_auth_enabled = false
  end
end
