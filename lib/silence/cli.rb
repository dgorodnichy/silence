require "thor"
require 'fileutils'

module Silence

  class Setup < Thor
    desc "new NAME", "This will setup new project"
    option :upcase

    def new(name)
      check_system_packages('Xvfb', 'firefox')
      Dir.mkdir(name) unless File.exists?(name)
      copy_project_structure(name)
      generate_file("#{name}/.ruby-gemset", name)
      generate_file("#{name}/.ruby-version", "ruby-2.2.2")
    end

    no_commands do

      def check_system_packages(*packages)
        missing_packages = []
        packages.each do |package| 
          missing_packages << package if `which #{package}`.empty?
        end
        if missing_packages.size > 0
          begin
            raise
          rescue Exception => e
            missing_packages.each do |package|  
              color_output("#{package} should be installed!", 31)
            end
          end
        end
      end

      def color_output(string, color=29)
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
