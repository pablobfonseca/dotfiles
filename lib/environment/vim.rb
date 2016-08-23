module Environment
  class Vim
    include Environment::Utils

    attr_reader :path

    def initialize(options={})
      @path = options.fetch('path') do
        ENV.fetch('VIM_FILES') { File.join(ENV.fetch('HOME'), '.vim') }
      end
    end

    def install
      prompt "Install Vundle? [ynq]"

      case STDIN.gets.chomp
      when 'y'
        say "Installing Vundle"

        backup_file(path) if File.exists?(path)

        system %{export VIM_FILES="#{path}"}
        system %{mkdir -p #{path}/_temp}
        system %{mkdir -p #{path}/_backup}
        system %{git clone https://github.com/VundleVim/Vundle.vim.git #{path}}
      when 'q'
        exit
      else
        say "Skipping Vundle"
      end
    end

    def update
      say "Updating Vundle and plugins"

      if path && File.exists?(path)
        system %{vim -c ':BundleUpdate | qall!'}
      else
        say "VIM_FILES not found", :error
      end
    end
  end
end
