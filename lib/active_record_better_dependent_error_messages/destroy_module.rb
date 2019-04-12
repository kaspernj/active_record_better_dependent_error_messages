module ActiveRecordBetterDependentErrorMessages::DestroyModule
  def destroy(*_args)
    result = super

    if !result && errors.empty?
      ActiveRecordBetterDependentErrorMessages::DestroyValidator.(model: self)
    end

    result
  end
end
