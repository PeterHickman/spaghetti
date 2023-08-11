# frozen_string_literal: true

class ForData
  attr_reader :variable, :target, :label, :step, :target_is_var, :step_is_var

  def initialize(variable, target, label, step, target_is_var, step_is_var)
    @variable = variable
    @target = target
    @label = label
    @step = step
    @target_is_var = target_is_var
    @step_is_var = step_is_var
  end
end
