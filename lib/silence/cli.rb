require "thor"
require 'fileutils'

module Silence

  class Setup < Thor
    desc "new NAME", "This will setup new project"
    option :upcase

    def new(name)
      Dir.mkdir(name) unless File.exists?(name)
      copy_project_structure(name)
      generate_file("#{name}/.ruby-gemset", name)
      generate_file("#{name}/.ruby-version", "ruby-2.2.0")
      system("cd #{name} && bundle")
    end

    no_commands do

      def color_output(string, color)
        printf "\033[#{color}m#{string}\033[0m\n"
      end

      def generate_file(path_to_file, content)
        File.open(path_to_file, "w+") { |file| file.write(content) }
      end

      def copy_project_structure(project_name)
        spec = Gem::Specification.find_by_name 'silence'       
        FileUtils.cp_r "#{spec.gem_dir}/lib/.", "#{Dir.pwd}/#{project_name}", :verbose => true
      end

    end
  end

end
