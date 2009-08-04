module AuditLogger
  def self.included(base)
    base.send :extend, ClassMethods
  end 

  module ClassMethods
    def uses_audit_logger(audit_logger)
      send :include, InstanceMethods

      cattr_accessor :audit_logger
      self.audit_logger = audit_logger

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
      self.class.audit_logger.constantize.create(:object_class => self.class.name.to_s, :object_id => self.id, :audited_object => self.attributes.to_json, :changes => self.changes.to_json, :operation => operation)
    end
  end
end
