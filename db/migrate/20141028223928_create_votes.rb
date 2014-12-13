class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :up
      t.references :user, index: true
      t.references :source, index: true

      t.timestamps
    end
  end
end
