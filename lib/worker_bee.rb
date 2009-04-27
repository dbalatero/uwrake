require 'ostruct'

class WorkerBee
  VERSION = '1.0.0'

  @@work = {}

  def self.recipe(&block)
    raise ArgumentError, "WorkerBee#recipe requires a block." unless block_given?
    instance_eval(&block)
  end

  def self.reset_work
    @@work = {}
  end

  def self.run(name)
    
  end

  def self.work(name, *deps, &work)
    raise ArgumentError, "WorkerBee#work requires a block." unless block_given?

    @@work[name] = OpenStruct.new(:work => work,
                                  :dependencies => deps)
  end

  def self.work_count
    @@work.size
  end
end
