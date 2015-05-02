require "thor"
require 'fileutils'

module Silence

  class NewGenerator < Thor
    include Thor::Actions

    def self.source_root
      spec = Gem::Specification.find_by_name 'silence'       
      File.expand_path("#{spec.gem_dir}/lib/", __FILE__)
    end

    desc "new NAME", "This will setup new project"
    option :upcase
    def new(name)
      Dir.mkdir(name) unless File.exists?(name)
      copy_project_structure(name)
      setup_ruby_environment(name)
    end

    desc "example", "This will add example feature."
    def example
      copy_file "lib/example/example.feature", "features/example.feature"
      copy_file "lib/example/example_page.rb", "features/pages/example_page.rb"
      copy_file "lib/example/example_steps.rb", "features/step_definitions/example_steps.rb"
      copy_file "lib/example/example_widget.rb", "features/pages/widgets/example_widget.rb"
      copy_file "lib/example/urls.yml", "config/data/urls.yml"
      copy_file "lib/example/user_registration_dataset.yml", "features/data/user_registration_dataset.yml"
    end

    no_commands do

      def setup_ruby_environment(name)
        if yes? "Create .ruby-gemset and .ruby-version files? (y/n)"
          generate_file("#{name}/.ruby-gemset", name)
          generate_file("#{name}/.ruby-version", "ruby-2.2.2")
        end
      end

      def color_output(string, color=29)
        printf "\033[#{color}m#{string}\033[0m\n"
      end

      def generate_file(path_to_file, content)
        create_file path_to_file do
          content
        end
      end

      def copy_project_structure(project_name)
        directory ".", "#{Dir.pwd}/#{project_name}", 
        :exclude_pattern => /silence/, :exclude_pattern => /^bin$/, :exclude_pattern => /^example$/
      end

    end
  end

end
