class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  configure_replica_connections

  # PostgreSQL adapter doesn't auto-generate UUIDs in Ruby like Trilogy does.
  # Generate a UUID before create when the id is not set. Skip tables with an
  # integer primary key (e.g. the SQLite search_records table), which rely on
  # auto-increment — forcing a UUID string there collides on the integer column.
  before_create :ensure_uuid_primary_key

  private
    def ensure_uuid_primary_key
      return if self.class.columns_hash[self.class.primary_key]&.type == :integer
      self.id = SecureRandom.uuid if id.blank?
    end
end
