# frozen_string_literal: true

class CreateTokenBlacklist < ActiveRecord::Migration[5.2]
  def change
    create_table :token_blacklists do |t|
      t.string :jwt_token

      t.timestamp :expiration_date

      t.timestamps
    end
  end
end
