# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/worker_bee.rb'

Hoe.new('worker_bee', WorkerBee::VERSION) do |p|
  #p.rubyforge_name = 'worker_beex' # if different than lowercase project name
  p.developer('David Balatero', 'dbalatero@gmail.com')
end

require 'rake'
require 'spec/rake/spectask'

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new('spec_rcov') do |t|
  t.spec_files = FileList['spec/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
end

# vim: syntax=Ruby
