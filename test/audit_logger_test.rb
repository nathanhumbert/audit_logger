require File.dirname(__FILE__) + '/test_helper.rb' 

class Foo < ActiveRecord::Base
  uses_audit_logger("AuditLogEntry")
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
  
  test "use_audit_logger" do
    foo = nil
    assert_difference("AuditLogEntry.count") do 
      foo = Foo.create(:foo_name => "testing")
    end
    assert_difference("AuditLogEntry.count") do
      foo.foo_name = "testing 123"
      foo.description = "this is a test"
      foo.save
    end
    assert_difference("AuditLogEntry.count") do
      foo.destroy
    end
  end

  test "that schema loaded correctly" do
    assert_equal [], Foo.all
    assert_equal [], Bar.all
  end
end
