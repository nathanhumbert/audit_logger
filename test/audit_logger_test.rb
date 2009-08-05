require File.dirname(__FILE__) + '/test_helper.rb' 

class Foo < ActiveRecord::Base
  uses_audit_logger("AuditLogClassNoOneWillEverUseEntry")
end

class Bar < ActiveRecord::Base
end

class AuditLoggerTest < ActiveSupport::TestCase
  def setup
    run_generator
    require model_file
  end
  
  def teardown
    cleanup_after_generator
  end

  test "uses_audit_logger puts correct data in log" do 
    foo = Foo.create(:foo_name => "testing")
    assert_equal 1, foo.audit_log_class_no_one_will_ever_use_entries.count
    assert_equal foo.foo_name, Foo.new.from_json(foo.audit_log_class_no_one_will_ever_use_entries.first.object_attributes).foo_name
    assert foo.audit_log_class_no_one_will_ever_use_entries.first.object_changes.include?('"foo_name": [null, "testing"]')
    assert_equal "Create", foo.audit_log_class_no_one_will_ever_use_entries.first.operation
  end
  
  test "uses_audit_logger" do
    foo = nil
    assert_difference("AuditLogClassNoOneWillEverUseEntry.count", 3) do
      assert_difference("AuditLogClassNoOneWillEverUseEntry.count(:conditions => \"operation = 'Create'\")") do 
        foo = Foo.create(:foo_name => "testing")
      end
      assert_difference("AuditLogClassNoOneWillEverUseEntry.count(:conditions => \"operation = 'Update'\")") do
        foo.foo_name = "testing 123"
        foo.description = "this is a test"
        foo.save
      end
      assert_difference("AuditLogClassNoOneWillEverUseEntry.count(:conditions => \"operation = 'Destroy'\")") do
        foo.destroy
      end
    end
  end

  test "bar should not use audit logger" do
    bar = nil
    assert_no_difference("AuditLogClassNoOneWillEverUseEntry.count") do 
      bar = Bar.create(:bar_name => "testing")
    end
    assert_no_difference("AuditLogClassNoOneWillEverUseEntry.count") do
      bar.bar_name = "testing 123"
      bar.description = "this is a test"
      bar.save
    end
    assert_no_difference("AuditLogClassNoOneWillEverUseEntry.count") do
      bar.destroy
    end
  end

  test "that schema loaded correctly" do
    assert_equal [], Foo.all
    assert_equal [], Bar.all
  end
end
