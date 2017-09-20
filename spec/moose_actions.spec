require_relative '../lib/moose_action.rb'
require_relative '../lib/moose_actions.rb'

RSpec.describe MooseActions do 
  let(:flow_class) { Class.new { include(MooseActions) } }
  let(:flow) { flow_class.new }
  let(:action) do
    MooseAction.new(:click) do 
      action {"Bar"} 
    end
  end

  context "Class methods extended" do
    it "It can be included" do
      expect(flow_class.moose_actions).to be_a Hash
    end

    it "Can define a new action" do 
      flow_class.define_action(:defined_action){}
      expect(flow_class.moose_actions[:defined_action]).to be_a MooseAction
    end
  end

  context "Class instances included" do 
    it "action cache can be accessed by instances" do
      allow(flow_class).to receive(:moose_actions).and_return({ click: "FakeAction" })
      expect(flow.moose_actions[:click]).to eq "FakeAction"
    end

    it "Can execute an action defined in the class" do 
      allow(flow_class).to receive(:moose_actions).and_return({click: action})
      expect(action).to receive(:action_sequence)
      flow.do_action :click
    end

    it "Can execute Anonymous Actions" do
      expect_any_instance_of(MooseAction).to receive(:action_sequence)
      flow.action :anonymous do 
        action { "Baz" }
      end
    end
  end
end

