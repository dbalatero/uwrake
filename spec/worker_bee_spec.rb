require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe WorkerBee do
  describe "recipe" do
    it "should require a block of code to be passed in" do
      lambda { WorkerBee.recipe }.should raise_error(ArgumentError)
    end

    it "should execute the passed block in the correct context" do
      block = lambda { 5 + 5 }
      WorkerBee.should_receive(:instance_eval).and_yield
      WorkerBee.recipe(&block)
    end
  end

  describe "run" do
    it "should execute the code for given task name" do
      run_count = 0
      WorkerBee.work(:foo) { run_count += 1 }

      WorkerBee.run(:foo)
      run_count.should == 1
    end

    it "should execute dependencies in order" do
      execution_path = []
      WorkerBee.work(:first) { execution_path << :first }
      WorkerBee.work(:second, :first) { execution_path << :second }

      WorkerBee.run(:second)
      execution_path.should == [:first, :second]
    end

    it "should handle diamond dependencies correctly" do
      execution_path = []
      WorkerBee.work(:sammich, :meat, :bread) { execution_path << :sammich }
      WorkerBee.work(:meat, :clean) { execution_path << :meat }
      WorkerBee.work(:bread, :clean) { execution_path << :bread }
      WorkerBee.work(:clean) { execution_path << :clean }

      WorkerBee.run(:sammich)
      execution_path.should == [:clean, :meat, :bread, :sammich]
    end
  end

  describe "work" do
    before(:each) do
      # Have a clean state each test.
      WorkerBee.reset_work
    end

    it "should require a recipe block to be passed in" do
      lambda { WorkerBee.work(:name) }.should raise_error(ArgumentError)
    end

    it "should save a given block under a recipe name" do
      lambda {
        WorkerBee.work(:foo) do
          puts "hello!"
        end
      }.should change(WorkerBee, :work_count).by(1)
    end
  end
end
