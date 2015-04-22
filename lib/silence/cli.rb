require "thor"
require 'fileutils'

module Silence

  class Setup < Thor
    desc "new NAME", "This will setup new project"
    option :upcase

    def new(name)
      Dir.mkdir(name) unless File.exists?(name)
      copy_project_structure
      setup_ruby_version("ruby-2.2.0")
      setup_gemset(name)
      color_output(system("rvm gemset list"), 34)
      system("cd #{name} && bundle")
    end

    no_commands do

      def color_output(string, color)
        printf "\033[#{color}m#{string}\033[0m\n"
      end

      def setup_gemset(name)
        File.new("#{name}/.ruby-gemset") { |file| file.puts(name) }
      end

      def setup_version(version)
        File.new("#{name}/.ruby-version") { |file| file.puts(version) }
      end

      def copy_project_structure
        spec = Gem::Specification.find_by_name 'silence'       
        FileUtils.cp_r "#{spec.gem_dir}/lib/.", "#{Dir.pwd}/#{name}", :verbose => true
      end

    end
  end

end
