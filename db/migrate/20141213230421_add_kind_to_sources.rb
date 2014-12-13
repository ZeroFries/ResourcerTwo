class AddKindToSources < ActiveRecord::Migration
  def change
  	add_column :sources, :kind, :integer
  end
end
