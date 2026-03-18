class AddUuidDefaultsForPostgresql < ActiveRecord::Migration[8.2]
  def up
    return unless connection.adapter_name == "PostgreSQL"

    # Ensure gen_random_uuid() is available (built-in on PG 13+, needs pgcrypto on older)
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    # Find all tables with UUID primary keys that lack a default
    tables = connection.tables - %w[schema_migrations ar_internal_metadata]
    tables.each do |table|
      columns = connection.columns(table)
      pk = columns.find { |c| c.name == "id" }
      next unless pk && pk.sql_type == "uuid" && pk.default.nil?

      execute "ALTER TABLE #{quote_table_name(table)} ALTER COLUMN id SET DEFAULT gen_random_uuid()"
    end
  end

  def down
    # No-op: removing defaults would break inserts
  end
end
