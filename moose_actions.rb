module MooseActions
  
  def self.included(base)
    base.extend(ClassMethods)
    base.moose_actions = {}
  end

  def do_action( action )
    self.class.moose_actions.fetch(action).action_sequence
  end

  module ClassMethods
    attr_accessor :moose_actions

    def define_action(name, &block)
      moose_actions[name] = MooseAction.new(name, &block)
    end
  end
end
