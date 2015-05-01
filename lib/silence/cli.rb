require "thor"
require 'fileutils'

module Silence

  class NewGenerator < Thor::Group
    include Thor::Actions

    desc "new NAME" #, "This will setup new project"
    argument :name
    #option :upcase
    
    def self.source_root
      spec = Gem::Specification.find_by_name 'silence'       
      File.expand_path("#{spec.gem_dir}/lib/", __FILE__)
    end

    def new
      Dir.mkdir(name) unless File.exists?(name)
      copy_project_structure(name)
      generate_file("#{name}/.ruby-gemset", name)
      generate_file("#{name}/.ruby-version", "ruby-2.2.2")
    end

    no_commands do

      def color_output(string, color=29)
        printf "\033[#{color}m#{string}\033[0m\n"
      end

      def generate_file(path_to_file, content)
        File.open(path_to_file, "w+") { |file| file.write(content) }
      end

      def copy_project_structure(project_name)
        #FileUtils.cp_r "#{spec.gem_dir}/lib/.", "#{Dir.pwd}/#{project_name}", :verbose => true
        directory ".", "#{Dir.pwd}/#{project_name}"
      end

    end
  end

end
