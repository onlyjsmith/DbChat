class CreateFolders < ActiveRecord::Migration
  def self.up
    create_table :folders do |t|
      t.string :url
      t.string :title
      t.string :location

      t.timestamps
    end
  end

  def self.down
    drop_table :folders
  end
end
