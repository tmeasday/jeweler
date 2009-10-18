require 'rake'
require 'rake/tasklib'

class Jeweler
  # Rake tasks for putting a Jeweler gem onto a local gem server, via ssh.
  #
  # Jeweler::Tasks.new needs to be used before this.
  #
  # Basic usage:
  #
  #     Jeweler::Local.new do |s|
  #        s.ssh_host => '[user@]host' [default 'localhost']
  #        s.host_dir => '/path/to/gem/files' [default '~']
  #     end
  #
  class LocalTasks < ::Rake::TaskLib
    attr_accessor :jeweler
    attr_accessor :ssh_host, :host_dir

    def initialize
      yield self if block_given?
      
      define
    end
    
    def jeweler
      @jeweler ||= Rake.application.jeweler
    end
    
    def ssh_host
      @ssh_host ||= 'localhost'
    end
    
    def host_dir
      @host_dir ||= '~'
    end

    def define
      namespace :local do
        desc "Release gem to Local gem server"
        task :release => [:gemspec, :build] do
          jeweler.release_gem_to_local(ssh_host, host_dir)
        end
      end

      task :release => 'local:release'
    end
  end
end
