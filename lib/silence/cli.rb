require "thor"
require 'fileutils'

module Silence

  class Setup < Thor
    desc "new NAME", "This will setup new project"
    option :upcase

    def new(name)
      spec = Gem::Specification.find_by_name 'silence'       
      FileUtils.cp_r "#{spec.gem_dir}/lib/.", Dir.pwd, :verbose => true
      color_output(system("rvm gemset list"), 34)
      system("bundle")
    end

    no_commands do

      def color_output(string, color)
        printf "\033[#{color}m#{string}\033[0m\n"
      end

    end
  end

end
