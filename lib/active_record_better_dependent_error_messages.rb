require "active_record_better_dependent_error_messages/engine"

module ActiveRecordBetterDependentErrorMessages
  path = "#{File.dirname(__FILE__)}/active_record_better_dependent_error_messages"

  autoload :DestroyModule, "#{path}/destroy_module"
  autoload :DestroyValidator, "#{path}/destroy_validator"
end
