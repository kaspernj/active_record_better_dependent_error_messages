module ActiveRecordBetterDependentErrorMessages::DestroyModule
  def self.included(base)
    base.define_method(:destroy) do
      ActiveRecordBetterDependentErrorMessages::DestroyValidator.(model: self)
      return false if errors.any?
      super
    end
  end
end
