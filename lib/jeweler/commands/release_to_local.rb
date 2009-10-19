class Jeweler
  module Commands
    class ReleaseToLocal
      attr_accessor :gemspec, :version, :output, :gemspec_helper
      attr_accessor :ssh_host, :host_dir

      def initialize
        self.output = $stdout
      end

      def run
        # copy gem to local server
        command = ['scp', @gemspec_helper.gem_path, "#{ssh_host}:#{host_dir}/gems"]
        output.puts "Executing #{command.join(' ')}:"
        sh *command # will throw an exception if there is a problem
        
        # re-index local gems
        command = ['ssh', ssh_host, '-C', "cd #{host_dir}; gem generate_index"]
        output.puts "Executing #{command.join(' ')}:"
        sh *command
      end

      def self.build_for(jeweler)
        command = new
        command.gemspec        = jeweler.gemspec
        command.gemspec_helper = jeweler.gemspec_helper
        command.version        = jeweler.version
        command.output         = jeweler.output
        command
      end
    end
  end
end
