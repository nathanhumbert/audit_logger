ActiveRecord::Schema.define(:version => 0) do

  create_table :foos, :force => true do |t|
    t.string :foo_name
    t.string :description
    t.timestamps
  end

  create_table :bars, :force => true do |t|
    t.string :bar_name
    t.string :description
    t.timestamps
  end

  create_table :audit_log_entries, :force => true do |t|
    t.text :object_attributes
    t.text :object_changes
    t.text :operation
    t.text :audited_object_type
    t.integer :audited_object_id

    t.timestamps
  end


end
