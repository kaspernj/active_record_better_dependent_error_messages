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

      if has_one_model && !has_error?
        root_model.errors.add(
          :base,
          :cannot_delete_because_of_restriction,
          association_name: association.klass.model_name.human(count: 1).downcase,
          count: 1,
          message: "Cannot delete because of #{trace_as_string} has dependent record: #{association.name} with ID: #{has_one_model.id}",
          model_name: model.model_name.human.downcase
        )
      end
    elsif association.macro == :has_many && !has_error?
      ids = model.__send__(association.name).pluck(:id)

      if ids.any?
        root_model.errors.add(
          :base,
          :cannot_delete_because_of_restriction,
          association_name: association.klass.model_name.human(count: 2).downcase,
          count: ids.length,
          message: "Cannot delete because of #{trace_as_string} has dependent records: #{association.name} with IDs: #{ids.join(", ")}",
          model_name: model.model_name.human.downcase
        )
      end
    end
  end

  def check_sub_destroy_association(association)
    if association.macro == :has_one
      sub_model = model.association(association.name).target

      if sub_model
        extract_sub_destroy_errors(association, sub_model)
        ActiveRecordBetterDependentErrorMessages::DestroyValidator.(root_model: root_model, model: sub_model, trace: trace + [sub_model])
      end
    elsif association.macro == :has_many
      sub_models = model.association(association.name).target

      sub_models.each do |sub_model_i|
        extract_sub_destroy_errors(association, sub_model_i)
        ActiveRecordBetterDependentErrorMessages::DestroyValidator.(root_model: root_model, model: sub_model_i, trace: trace + [sub_model_i])
      end
    end
  end

  def extract_sub_destroy_errors(association, model)
    return unless model_has_custom_errors?(model)

    root_model.errors.add(
      :base,
      :cannot_delete_because_of_child_errors,
      association_name: association.klass.model_name.human(count: 2).downcase,
      count: 1,
      message: "Cannot delete because of child errors in #{association.name} with IDs: #{model.id}: #{model.errors.full_messages.join(". ")}",
      model_name: model.model_name.human.downcase
    )
  end

  def model_has_custom_errors?(model)
    custom_errors = 0

    model.errors.details.each do |error_types_with_detail|
      attribute = error_types_with_detail.fetch(0)
      errors = error_types_with_detail.fetch(1)

      errors.each do |error|
        custom_errors += 1 unless error.fetch(:error) == :"restrict_dependent_destroy.has_many"
      end
    end

    custom_errors > 0
  end

  def has_error?
    root_model.errors.details[:base] && root_model.errors.details[:base].any? { |error| error[:error] == :cannot_delete_because_of_restriction }
  end

  def trace_as_string
    trace.map do |model|
      "#{model.class.name}(#{model.id})"
    end.join(" -> ")
  end
end
