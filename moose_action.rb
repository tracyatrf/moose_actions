class MooseAction
  attr_accessor :name, :ensure_before_block, :action_block, :error_block

  def initialize(name, &block)
    @name = name
    block.call(self)
  end

  def ensure_before(&block)
    @ensure_before_block = block
  end

  def action(&block)
    @action_block = block
  end

  def error(&block)
    @error_block = block
  end

  def action_sequence
    begin
      raise unless @ensure_before_block.call
      @action_block.call
    rescue => e
      error_block ? error_block.call : (raise "Could not complete #{name} action")
    end
  end
end
