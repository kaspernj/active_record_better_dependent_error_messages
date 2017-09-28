class ActiveRecordBetterDependentErrorMessages::DestroyValidator
  attr_reader :args, :root_model, :model, :trace

  def initialize(root_model:, model:, trace:, args:)
    @args = args
    @root_model = root_model
    @model = model
    @trace = trace
  end

  def self.call(root_model: nil, model:, trace: nil, **args)
    root_model ||= model
    trace ||= [model]

    ActiveRecordBetterDependentErrorMessages::DestroyValidator.new(root_model: root_model, model: model, trace: trace, args: args).()
  end

  def call
    model.class.reflect_on_all_associations.each do |association|
      if association.options[:dependent] == :restrict_with_error || association.options[:dependent] == :restrict_with_exception
        check_restrict_association(association)
      elsif association.options[:dependent] == :destroy
        check_sub_destroy_association(association)
      end
    end
  end

private

  def check_restrict_association(association)
    if association.macro == :has_one
      has_one_model = model.__send__(association.name)

      if has_one_model
        root_model.errors.add(:base, "Cannot delete because of #{trace_as_string} has dependent record: #{association.name} with ID: #{has_one_model.id}")
      end
    elsif association.macro == :has_many
      ids = model.__send__(association.name).pluck(:id)
      if ids.any?
        root_model.errors.add(:base, "Cannot delete because of #{trace_as_string} has dependent records: #{association.name} with IDs: #{ids.join(", ")}")
      end
    end
  end

  def check_sub_destroy_association(association)
    if association.macro == :has_one
      sub_model = model.__send__(association.name)
      ActiveRecordBetterDependentErrorMessages::DestroyValidator.(root_model: root_model, model: sub_model, trace: trace + [sub_model]) if sub_model
    elsif association.macro == :has_many
      sub_models = model.__send__(association.name)
      sub_models.find_each do |sub_model_i|
        ActiveRecordBetterDependentErrorMessages::DestroyValidator.(root_model: root_model, model: sub_model_i, trace: trace + [sub_model_i])
      end
    end
  end

  def trace_as_string
    trace.map do |model|
      "#{model.class.name}(#{model.id})"
    end.join(" -> ")
  end
end
