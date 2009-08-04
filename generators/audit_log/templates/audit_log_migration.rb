class <%= class_name %> < ActiveRecord::Migration
  def self.up
    create_table <%= table_name %> do |t|
      t.text :audited_object
      t.text :changes
      t.text :operation
      t.text :object_class
      t.integer :object_id

      t.timestamps
    end
  end

  def self.down
    drop_table <%= table_name %>
  end
end
