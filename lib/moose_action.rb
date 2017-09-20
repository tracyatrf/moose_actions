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
    raise PreconditionNotMet if ensure_before_block and context.instance_exec(*args, &ensure_before_block) == false
    return_value = begin
      context.instance_exec *args, &action_block
    rescue => error
      error_block ? context.instance_exec(*args, &error_block) : (raise "Could not complete #{name} action -- #{error}")
    end
    raise PostconditionNotMet if ensure_after_block and context.instance_exec(*args, &ensure_after_block) == false
    return_value
  end
end
