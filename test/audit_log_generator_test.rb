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
    assert_match /create_audit_log_entries/, migration_file
    assert_match /class CreateAuditLogEntries/, migration_file_contents
    assert_match /create_table audit_log_entries/, migration_file_contents
    assert_match /drop_table audit_log_entries/, migration_file_contents
  end

  def test_generates_model_with_correct_file_name_and_contents
    assert_match /audit_log_entry/, model_file
    assert_match /class AuditLogEntry/, File.read(model_file)
  end

end
