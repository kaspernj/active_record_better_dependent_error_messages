class ActiveRecordBetterDependentErrorMessages::ErrorsCollector
  attr_reader :model, :root_model

  def self.call(model:, root_model: nil)
    root_model ||= model

    collector = ActiveRecordBetterDependentErrorMessages::ErrorsCollector.new(model: model, root_model: root_model)
    collector.collect!
  end

  def initialize(model:, root_model:)
    @model = model
    @root_model = root_model
  end

  def collect!
    model._reflections.each do |reflection_name, reflection|
      association = model.association(reflection_name)

      next if reflection.options[:dependent] != :destroy

      if reflection.macro == :has_many
        model.__send__(reflection_name).each do |sub_model|
          scan_sub_model_for_errors(sub_model)
          ActiveRecordBetterDependentErrorMessages::ErrorsCollector.(model: sub_model, root_model: model)
        end
      elsif reflection.macro == :has_one
        sub_model = model.__send__(reflection_name)
        scan_sub_model_for_errors(sub_model)
        ActiveRecordBetterDependentErrorMessages::ErrorsCollector.(model: sub_model, root_model: model)
      end
    end
  end

  def scan_sub_model_for_errors(sub_model)
    return if sub_model.errors.none?

    root_model.errors.add(:base, sub_model.errors.full_messages.join(". "))
  end
end
