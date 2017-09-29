module ActiveRecordBetterDependentErrorMessages::DestroyModule
  def destroy
    result = super

    if !result && errors.empty?
      ActiveRecordBetterDependentErrorMessages::DestroyValidator.(model: self)
    end

    result
  end
end
