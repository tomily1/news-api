# frozen_string_literal: true

class AddTokenToAdminUsers < ActiveRecord::Migration[5.2]
  def change
    add_column(:admin_users, :token, :text)
    add_index(:admin_users, :token)
  end
end
