require File.dirname(__FILE__) + '/test_helper.rb'
require 'rails_generator'
require 'rails_generator/scripts/generate'

class AuditLogGeneratorTest < Test::Unit::TestCase
  def setup
    run_generator
  end
  
  def teardown
    cleanup_after_generator
  end

  def test_generates_migration_with_correct_file_name_and_contents
    migration_file = migration_file_list.last
    migration_file_contents = File.read(migration_file)
    assert_match /create_audit_log_class_no_one_will_ever_use_entries/, migration_file
    assert_match /class CreateAuditLogClassNoOneWillEverUseEntries/, migration_file_contents
    assert_match /create_table :audit_log_class_no_one_will_ever_use_entries/, migration_file_contents
    assert_match /drop_table :audit_log_class_no_one_will_ever_use_entries/, migration_file_contents
  end

  def test_generates_model_with_correct_file_name_and_contents
    assert_match /audit_log_class_no_one_will_ever_use_entry/, model_file
    assert_match /class AuditLogClassNoOneWillEverUseEntry/, File.read(model_file)
  end

end
