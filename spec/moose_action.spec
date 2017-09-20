require_relative '../lib/moose_action.rb'

RSpec.describe MooseAction do
  context "With a valid name and block" do
    let(:subject) { MooseAction.new(:click){} }

    it "Is a MooseAction" do
      expect(subject).to be_a described_class
    end

    context "With hook blocks defined" do
      let(:subject) do
        MooseAction.new(:click) do
          ensure_before { "before" }
          action { "action" }
          ensure_after { "after" }
        end
      end

      it "Saves the before block to be called later" do
        expect(subject.ensure_before_block).to be_a Proc
        expect(subject.ensure_before_block.call).to eq "before"
      end

      it "Saves the after block to be called later" do
        expect(subject.ensure_after_block).to be_a Proc
        expect(subject.ensure_after_block.call).to eq "after"
      end

      it "Saves the action block to be called later" do
        expect(subject.action_block).to be_a Proc
        expect(subject.action_block.call).to eq "action"
      end
    end

    context "Action Sequence" do 
      let(:flow) { double("flow", foo: 1, bar: 2, baz: 3) }
      let(:subject) do
        MooseAction.new(:click) do
          ensure_before { foo }
          action { bar }
          ensure_after { baz }
          error { raise FakeError }
        end
      end

      it "returns the value of the action" do 
        expect(subject.action_sequence(flow)).to eq 2
      end

      it "Executes in the context of the passed object" do 
        expect(flow).to receive(:foo)
        expect(flow).to receive(:bar)
        expect(flow).to receive(:baz)
        subject.action_sequence(flow)
      end

      context "With Error block" do
        let(:subject) do
          MooseAction.new(:click) do
            action { raise "ErrorError" }
            error { foo }
          end
        end

        it "error block called when action block raises error" do 
          expect(flow).to receive(:foo)
          subject.action_sequence(flow)
        end

      end

      context "Without Error Block" do 
        let(:subject) do
          MooseAction.new(:click) do
            action { raise "ErrorError" }
          end
        end

        it "calls a standard error with action name" do 
          expect{ subject.action_sequence(flow)}.to raise_error(RuntimeError, /click/)
        end
      end
    end
  end
end
