module Environment
  class Vim::Plugins
    include Environment::Utils

    def install
      prompt "Install vim plugins? [ynq]"

      case STDIN.gets.chomp
      when 'y'
        install_neo_bundle
      when 'q'
        exit
      else
        say "Skipping Vim plugins"
      end
    end

    def update
      say "Updating Vim plugins"

      update_neo_bundle
    end

    private

    def install_neo_bundle
      prompt "Installing NeoBundle..."

      system "cd"
      system "curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > install.sh " 
      system "sh ./install.sh"
      system "rm install.sh"
      install_plugins
    end

    def install_plugins
      prompt "Installing plugins..."

      system "vim +NeoBundleInstall"
    end

    def update_plugins
      prompt "Updating plugins..."

      system "vim +NeoBundleUpdate"
    end
  end
end
