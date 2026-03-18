class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  configure_replica_connections

  # PostgreSQL adapter doesn't auto-generate UUIDs in Ruby like Trilogy does.
  # Generate a UUID before create when the id is not set.
  before_create :ensure_uuid_primary_key

  private
    def ensure_uuid_primary_key
      self.id = SecureRandom.uuid if id.blank?
    end
end
