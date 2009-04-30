require 'ostruct'

class WorkerBee
  VERSION = '1.0.0'

  @@work = {}
  @@current_run = {}

  def self.recipe(&block)
    raise ArgumentError, "WorkerBee#recipe requires a block." unless block_given?
    instance_eval(&block)
  end

  def self.io_stream
    STDOUT
  end

  def self.reset_work
    @@work = {}
  end

  def self.run(name)
    execute(name, 0)
    @@current_run = {}
  end

  def self.execute(name, level)
    current = @@work[name]
    raise ArgumentError, "#{name} is not a valid task!" if current.nil?

    # TODO(dbalatero): synchronize this
    if @@current_run[name]
      # One base case, in which we already ran this dep.
      return
    end
    
    if !current.dependencies.empty?
      # Run the dependencies.
      current.dependencies.each do |dep|
        execute(dep, level + 1)
      end
    end

    # Finally, run this task.
    io_stream.puts("  " * level) + "running #{name}"
    current.work.call

    # TODO(dbalatero): synchronize this.
    @@current_run[name] = true
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
