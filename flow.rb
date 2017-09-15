class Flow
  include MooseActions
  
  define_action(:some_action) do |action|
    action.ensure_before { true }
    action.action { puts "this is an action" } 
  end

  define_action(:another_action) do |action|
    action.ensure_before { true }
    action.action { puts "this is another action" } 
  end

  define_action(:third_action) do |action|
    action.ensure_before { false }
    action.action { puts "this is a third action" } 
  end
end
