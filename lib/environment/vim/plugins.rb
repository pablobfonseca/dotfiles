module Environment
  class Vim::Plugins
    include Environment::Utils

    def install
      prompt "Install vim plugins? [ynq]"

      case STDIN.gets.chomp
      when 'y'
        sync_vim_plugins
      when 'q'
        exit
      else
        say "Skipping vim plugins"
      end
    end

    def update
      say "Updating vim plugins"

      sync_vim_plugins
    end

    private

    def sync_vim_plugins
      system %{vim -c ':PlugUpdate | qa!'}
    end
  end
end
