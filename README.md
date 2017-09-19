# This is supposed to be a DSL for creating "actions" 

Developed for use within integration test frameworks to facilitate a common construct.
Our team finds ourselves constantly writing the same style of code -- verify a condition, do an action, verify results.


## Usage

moose_actions supports both defining an action, and recalling it later with the `define_action` method, or you can just create an anonymous action using the `action` method. Both forms take the action definition block, however the `action` method will immediately execute, while the defined action can be recalled with `do_action :action_name`.

```
require 'moose_actions'
class Flow
  include MooseActions

  define_action :click do 
    ensure_before { true }
    action { puts "Stuff" }
    ensure_after { false }
    error { puts "uh ohs" }
  end
  
  def do_anonymous_action
    action do
      ensure_before { true }
      action { puts "Stuff" }
      ensure_after { true }
      error { puts "uh ohs" }
    end
  end

  def do_defined_action
    do_action :click
  end
end

flow = Flow.new

flow.do_anonymous_action
flow.do_defined_action

```
