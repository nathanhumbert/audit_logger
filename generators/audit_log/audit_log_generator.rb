class AuditLogGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.migration_template 'audit_log_migration.rb', "db/migrate", {
        :assigns => audit_log_migration_custom_assigns,
        :migration_file_name => "create_#{custom_file_name}_entries"
      }

      m.template 'audit_log_model.rb', "app/models/#{custom_file_name}_entry.rb", {
        :collision => :ask, 
        :assigns => audit_log_model_custom_assigns
      }
    end
  end


private

  def audit_log_migration_custom_assigns
    returning(assigns = {}) do
      assigns[:class_name] = "Create#{custom_file_name.camelize}Entries"
      assigns[:table_name] = custom_file_name + "_entries"
    end
  end

  def audit_log_model_custom_assigns
    returning(assigns = {}) do
      assigns[:class_name] = (custom_file_name + "_entries").classify
    end
  end

  def custom_file_name
    custom_name = class_name.underscore.downcase
  end

end
