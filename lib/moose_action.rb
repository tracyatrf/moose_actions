class MooseAction
  class PreconditionNotMet < StandardError; end
  class PostconditionNotMet < StandardError; end

  BLOCK_METHODS = [:ensure_before, :ensure_after, :action, :error]

  attr_accessor :name

  def initialize(name, &block)
    @name = name
    self.instance_exec self, &block
  end

  BLOCK_METHODS.each do |method|
    attr_accessor "#{method}_block"

    define_method(method) do |&block|
      send("#{method}_block=", block)
    end
  end

  def action_sequence(context, *args)
    before_sequence(context, args)
    return_value = main_sequence(context, args)
    after_sequence(context, args)
    return_value
  end

  def before_sequence(context, args)
    raise PreconditionNotMet if ensure_before_block and context.instance_exec(*args, &ensure_before_block) == false
  end

  def main_sequence(context, args)
    with_error(context, args) do
      context.instance_exec *args, &action_block
    end
  end

  def after_sequence(context, args)
    raise PostconditionNotMet if ensure_after_block and context.instance_exec(*args, &ensure_after_block) == false
  end

  def with_error(context, args)
    begin
      yield
    rescue => error
      error_block ? context.instance_exec(*args, &error_block) : (raise "Could not complete #{name} action -- #{error}")
    end
  end
end
