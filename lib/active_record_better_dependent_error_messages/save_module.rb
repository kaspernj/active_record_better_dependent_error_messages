module ActiveRecordBetterDependentErrorMessages::SaveModule
  def update(*args)
    super
  rescue ActiveRecord::RecordNotDestroyed => e
    raise e unless errors.empty?

    ActiveRecordBetterDependentErrorMessages::ErrorsCollector.(model: self)
    false
  end
end
