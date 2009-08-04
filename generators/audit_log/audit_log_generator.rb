class AuditLogGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.migration_template 'audit_log_migration.rb', "db/migrate", {
        :assigns => audit_log_migration_custom_assigns,
        :migration_file_name => "create_#{class_name.pluralize.underscore}"
      }

      m.template 'audit_log_model.rb', "app/models/#{class_name.underscore}.rb", {
        :collision => :ask, 
        :assigns => audit_log_model_custom_assigns
      }
    end
  end


private

  def audit_log_migration_custom_assigns
    returning(assigns = {}) do
      assigns[:class_name] = "Create#{class_name.pluralize}"
      assigns[:table_name] = class_name.pluralize.underscore
    end
  end

  def audit_log_model_custom_assigns
    returning(assigns = {}) do
      assigns[:class_name] = class_name
    end
  end

end
