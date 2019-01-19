class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.references :account, foreign_key: true, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
