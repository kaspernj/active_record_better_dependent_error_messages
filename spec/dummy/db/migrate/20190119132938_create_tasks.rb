class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :project, foreign_key: true, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
