require "thor"
require 'fileutils'

module Silence

  class Setup < Thor
    desc "new NAME", "This will setup new project"
    option :upcase

    def new(name)
      project_directories = ["features", 
                             "config", 
                             "reports",
                             "features/pages",
                             "features/step_definitions" ]

      Dir.mkdir(name) unless File.exists?(name)
      create_directories(name, project_directories)
    end

    no_commands do

      def color_output(string, color)
          printf "\033[#{color}m#{string}\033[0m\n"
      end

      def create_directories(name, directories)
        directories.each do |directory| 
          path = "#{name}/#{directory}"
          unless File.exists?(path)
            Dir.mkdir(path) 
            color_output("Create path: #{path}", 32)
          else
            color_output("Skipped: #{path}. Path already exists", 33)
          end
        end
      end

    end
  end

end
