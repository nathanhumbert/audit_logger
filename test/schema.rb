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
    t.text :audited_object
    t.text :changes
    t.text :operation
    t.text :object_class
    t.integer :object_id

    t.timestamps
  end


end
