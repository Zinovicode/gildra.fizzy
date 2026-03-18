class AddUniqueIndexToCardActivitySpikesOnCardId < ActiveRecord::Migration[8.2]
  def change
    reversible do |dir|
      dir.up do
        if ActiveRecord::Base.connection.adapter_name == "Trilogy"
          execute <<-SQL
            DELETE s1 FROM card_activity_spikes s1
            INNER JOIN card_activity_spikes s2
            WHERE s1.card_id = s2.card_id
            AND s1.updated_at < s2.updated_at
          SQL
        elsif ActiveRecord::Base.connection.adapter_name != "SQLite"
          execute <<-SQL
            DELETE FROM card_activity_spikes
            USING card_activity_spikes s2
            WHERE card_activity_spikes.card_id = s2.card_id
            AND card_activity_spikes.updated_at < s2.updated_at
          SQL
        end
      end
    end

    remove_index :card_activity_spikes, :card_id
    add_index :card_activity_spikes, :card_id, unique: true
  end
end
