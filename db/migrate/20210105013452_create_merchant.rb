# frozen_string_literal: true

class CreateMerchant < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants do |t|
      t.string :name

      t.timestamps
    end
  end
end
