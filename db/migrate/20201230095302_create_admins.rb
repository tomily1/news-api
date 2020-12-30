# frozen_string_literal: true

class CreateAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_users do |t|
      t.string    :email, null: false
      t.index     :email
      t.string    :password_digest
      t.boolean   :super_admin

      t.timestamps
    end
  end
end
