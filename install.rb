require 'thor'
require 'thor/group'

class DotfilesInstall < Thor::Group
  include Thor::Actions

  desc 'Configure tmux and vim'

  def self.source_root
    File.dirname(__FILE__) + '~/dotfiles'
  end

  def clone_repository
    %x[ git clone git@github.com:pablobfonseca/dotfiles.git ~/dotfiles ]
  end

  def link_vimrc
    system "ln -s vim/vimrc ~/.vimrc"
  end

  def link_tmux
    system "ln -s tmux ~/.tmux && ln -s tmux/tmux.conf ~/.tmux.conf"
  end
end

generator = DotfilesInstall.new
generator.destination_root = '~/'
generator.invoke_all
