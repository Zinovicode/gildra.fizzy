class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  configure_replica_connections

  # PostgreSQL adapter doesn't auto-generate UUIDs in Ruby like Trilogy does.
  # Generate a UUID before create if the primary key is UUID and not yet set.
  before_create :ensure_uuid_primary_key, if: -> { self.class.columns_hash["id"]&.sql_type == "uuid" }

  private
    def ensure_uuid_primary_key
      self.id ||= SecureRandom.uuid
    end
end
