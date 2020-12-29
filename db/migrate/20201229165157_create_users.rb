# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string    :email, null: false
      t.index     :email
      t.string    :password_digest

      t.timestamp
    end
  end
end