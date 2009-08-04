class <%= class_name %> < ActiveRecord::Base
  belongs_to :audited_object, :polymorphic => true
end
