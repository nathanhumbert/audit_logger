module AuditLogger
  def self.included(base)
    base.send :extend, ClassMethods
  end 

  module ClassMethods
    def uses_audit_logger(audit_logger)
      send :include, InstanceMethods

      cattr_accessor :audit_logger
      self.audit_logger = audit_logger

      has_many audit_logger.pluralize.underscore.to_sym, :as => :audited_object

      after_create :audit_log_create 
      after_update :audit_log_update
      after_destroy :audit_log_destroy
    end
  end

  module InstanceMethods
    private
    def audit_log_create
      create_audit_log_entry("Create")
    end

    def audit_log_update
      create_audit_log_entry("Update")
    end

    def audit_log_destroy
      create_audit_log_entry("Destroy")
    end

    def create_audit_log_entry(operation)
      self.class.audit_logger.constantize.create(:audited_object_type => self.class.name.to_s, :audited_object_id => self.id, :object_attributes => self.attributes.to_json, :object_changes => self.changes.to_json, :operation => operation)
    end
  end
end
