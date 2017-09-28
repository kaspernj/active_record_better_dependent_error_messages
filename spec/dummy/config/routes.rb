Rails.application.routes.draw do
  mount ActiveRecordBetterDependentErrorMessages::Engine => "/active_record_better_dependent_error_messages"
end
