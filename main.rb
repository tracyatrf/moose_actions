require_relative "./moose_action.rb"
require_relative "./moose_actions.rb"
require_relative "./flow.rb"


my_flow = Flow.new

my_flow.do_action :some_action
my_flow.do_action :another_action
my_flow.do_action :third_action
my_flow.do_action :some_action
