class <%= class_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name.to_sym %> do |t|
      t.text :object_attributes
      t.text :object_changes
      t.text :operation
      t.text :audited_object_type
      t.integer :audited_object_id

      t.timestamps
    end
  end

  def self.down
    drop_table :<%= table_name%>
  end
end
