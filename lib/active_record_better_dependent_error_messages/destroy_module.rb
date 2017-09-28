module ActiveRecordBetterDependentErrorMessages::DestroyModule
  def destroy
    ActiveRecordBetterDependentErrorMessages::DestroyValidator.(model: self)
    return false if errors.any?
    super
  end
end
