require_relative "moose_action"

module MooseActions
  def self.included(base)
    base.extend(ClassMethods)
    base.moose_actions = {}
  end

  def moose_actions
    self.class.moose_actions
  end

  def do_action( action, *args )
    moose_actions.fetch(action).action_sequence(self, *args)
  end

  def action(name = :unnamed, *args, &block)
    MooseAction.new(name, &block).action_sequence(self, *args)
  end

  module ClassMethods
    attr_accessor :moose_actions

    def define_action(name, &block)
      moose_actions[name] = MooseAction.new(name, &block)
    end
  end
end
