# This is supposed to be a DSL for creating "actions" 

Developed for use within integration test frameworks to facilitate a common construct.
Our team finds ourselves constantly writing the same style of code -- verify a condition, do an action, verify results.


## Usage
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
end

f = Flow.new
f.do_action :click
```
