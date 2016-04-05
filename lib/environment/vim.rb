module Environment
  module Vim
    include Environment::Utils

    attr_reader :path

    UPDATE_COMMAND = 'rake default'

    def initialize(options={})
      @path = options.fetch('path') do
        ENV.fetch('VIM_FILES') { File.join(ENV.fetch('HOME'), '.vim') }
      end
    end

    def install
      prompt "Install VIM? [ynq]"

      case STDIN.gets.chomp
      when 'y'
        say "Installing VIM"

        backup_file(path) if File.exists?(path)

        system %{brew install vim}
        system %{cd "$HOME/.vim" && rake}
        system %{export VIM_FILES="#{path}"}
      when 'q'
        exit
      else
        say "Skipping VIM"
      end
    end

    def update
      say 'Updating VIM'

      if path && File.exists?(path)
        system %{cd "#{path}" && #{UPDATE_COMMAND}}
      else
        say "VIM_FILES not found", :error
      end
    end
  end
end
