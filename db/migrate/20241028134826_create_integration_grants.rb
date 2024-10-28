# frozen_string_literal: true

class CreateIntegrationGrants < ActiveRecord::Migration[7.0]
  def change
    create_table(:integration_grants) do |t|
      t.references(:user, null: false, foreign_key: true)
      t.string(:provider, null: false)
      t.string(:domain, null: false)

      t.timestamps
    end
  end
end
