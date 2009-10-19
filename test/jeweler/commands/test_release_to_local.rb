require 'test_helper'

class Jeweler
  module Commands
    class TestReleaseToLocal < Test::Unit::TestCase
      def self.subject
        Jeweler::Commands::ReleaseToLocal.new
      end

      local_command_context "with vars set" do
        setup do
          stub(@gemspec_helper).gem_path {'pkg/zomg-1.2.3.gem'}
          stub(@command).sh
          stub(@command).ssh_host {'test_host'}
          stub(@command).host_dir {'dir'}
          @command.run
        end

        should "release to local" do
          copy_command = ['scp', 'pkg/zomg-1.2.3.gem', 'test_host:dir/gems']
          assert_received(@command) { |command| command.sh(*copy_command) }

          index_command = ['ssh', 'test_host', '-C', 'cd dir; gem generate_index']
          assert_received(@command) { |command| command.sh(*index_command) }
        end
      end

      build_command_context "build for jeweler" do
        setup do
          @command = Jeweler::Commands::ReleaseToLocal.build_for(@jeweler)
          @command.ssh_host = 'test_host'
          @command.host_dir = 'test_dir'
        end

        should "assign gemspec helper" do
          assert_equal @gemspec_helper, @command.gemspec_helper
        end

        should "assign output" do
          assert_equal @output, @command.output
        end
        
        should "assign ssh_host" do
          assert_equal 'test_host', @command.ssh_host
        end
        
        should "assign host_dir" do
          assert_equal 'test_dir', @command.host_dir
        end
      end
      
    end
  end
end
