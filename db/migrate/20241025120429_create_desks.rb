# frozen_string_literal: true

class CreateDesks < ActiveRecord::Migration[7.0]
  def change
    create_table(:desks) do |t|
      t.string(:name)
      t.string(:sync_id)

      t.timestamps
    end

    add_index(:desks, :sync_id, unique: true)
  end
end
